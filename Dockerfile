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
    libopenblas-dev libmpich-dev

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
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=$HOME/apps/conda .. && make -j4 && make install
WORKDIR $HOME/srcs/
RUN rm -rf STEPS

WORKDIR $HOME
