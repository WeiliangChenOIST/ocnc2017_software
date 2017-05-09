# terminal: docker run -d -p 5901:5901 -p 6901:6901 --name ocnc ocnc
# browser: http://localhost:6901/?password=vncpassword

# start from ubuntu 16.04
FROM consol/ubuntu-xfce-vnc:latest
MAINTAINER Weiliang Chen “w.chen@oist.jp”

USER 0

RUN apt-get update && apt-get install -y build-essential ca-certificates \
    bzip2 gcc g++ cmake \
    wget git swig \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    libncurses-dev \
    libopenblas-dev libmpich-dev \
    libx11-dev libxtst-dev xfonts-100dpi

RUN apt-get -y autoremove && apt-get -y purge python2.7-minimal

USER 1984

# Install Miniconda and packages
WORKDIR $HOME
RUN mkdir srcs

WORKDIR $HOME/srcs

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh -O ~/miniconda.sh && \
/bin/bash ~/miniconda.sh -b -p $HOME/apps/conda && \
rm ~/miniconda.sh

ENV PATH "$PATH:$HOME/apps/conda/bin:$HOME/apps/conda/bin/conda:$HOME/apps/conda/bin/python"
RUN $HOME/apps/conda/bin/conda install -y scipy numpy matplotlib ipython ipython-notebook jupyter pyqtgraph pyopengl nose

# Install STEPS
WORKDIR $HOME/srcs
RUN git clone https://github.com/CNS-OIST/STEPS.git
RUN mkdir STEPS/build
WORKDIR $HOME/srcs/STEPS/build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=$HOME/apps/conda .. && make -j 4 && make install

# WORKDIR $HOME/srcs/
# RUN rm -rf STEPS

# Install NEURON

WORKDIR $HOME/srcs
RUN wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/nrn-7.4.tar.gz && \
    wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/iv-19.tar.gz && \
    tar -xzf iv-19.tar.gz && \
    tar -xzf nrn-7.4.tar.gz

WORKDIR $HOME/srcs/iv-19
RUN ./configure --prefix=$HOME/apps/iv && \
    make -j 4 && \
    make install

WORKDIR $HOME/srcs/nrn-7.4
RUN ./configure --prefix=$HOME/apps/nrn --with-iv=$HOME/apps/iv --with-nrnpython=$HOME/apps/conda/bin/python && \
    make -j 4 && \
    make install

WORKDIR $HOME/srcs/nrn-7.4/src/nrnpython
RUN $HOME/apps/conda/bin/python setup.py install

ENV PATH $HOME/apps/nrn/x86_64/bin:$PATH/iv/x86_64/bin:$PATH
ENV LD_LIBRARY_PATH $PATH/nrn/x86_64/lib:$PATH/iv/x86_64/lib:$LD_LIBRARY_PATH

USER 0

RUN apt-get install -y scite nano xfce4-terminal && apt-get -y autoremove

ADD desktop /headless/Desktop
ADD documents /headless/Documents
RUN chown -R 1984:1984 /headless/Desktop/Applications /headless/Documents/notebooks

USER 1984
RUN chmod +x $HOME/Desktop/Applications/*.desktop

WORKDIR $HOME
