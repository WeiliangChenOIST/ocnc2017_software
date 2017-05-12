## Docker image for OCNC 2017

If you have any issue using the image please <a href="mailto:w.chen@oist.jp?Subject=OCNC2017%20docker%20issue" target="_top">email me</a>.

# Installation

1. Install Docker ([for MacOS](https://docs.docker.com/docker-for-mac/), [Windows](https://docs.docker.com/docker-for-windows/), and [Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntu/)).

2. Start Docker.

3. If you are using Windows, also [turn on drive sharing](https://rominirani.com/docker-on-windows-mounting-host-directories-d96f3f056a2c#.w4v0e42tn).

4. Open a terminal (or PowerShell for Windows), choose or create a directory which you would like to share your data between your host system and the docker virtual system, for example `c:\docker_shared` (Windows) or `$HOME/docker_shared` (Mac/Linux), and go to the above directory

   (Windows)
   ```shell
   md c:\docker_shared
   cd c:\docker_shared
   ```
   (Mac/Linux)
   ```shell
   mkdir $HOME/docker_shared
   cd $HOME/docker_shared
   ```
   
5. Download the docker image by entering the following in the terminal.

   ```shell
   docker pull wchenoist/ocnc2017_software
   ```
   
6. Initialize your own docker container (virtual system) with the image in a terminal. Note: Repeat this command will initialize another copy of the image system.

    (Mac/Linux)
   ```shell
   docker run -it -d -p 5901:5901 -p 6901:6901 -e  VNC_RESOLUTION=1360x768 -v $(pwd):/headless/Documents/Docker_shared --user 1984 --name ocnc_vm wchenoist/ocnc2017_software
   ```
   
   (Windows PowerShell)
   ```shell
   docker run -it -d -p 5901:5901 -p 6901:6901 -e  VNC_RESOLUTION=1360x768 -v ${pwd}:/headless/Documents/Docker_shared --user 1984 --name ocnc_vm wchenoist/ocnc2017_software
   ```   
   
# Use the system

1. Once the container is started, you can access the system via [http://localhost:6901/?password=vncpassword](http://localhost:6901/?password=vncpassword) from any browser that supports HTML5 (Chrome 8, Firefox 4, Safari 6, Opera 12, IE 11, Edge 12, etc.)

2. The system remains online even if you close your browser tab, to stop the system, use the following command in your host machine terminal.

   ```shell
   docker stop ocnc_vm
   ```
   To restart the same system and continue your work, use the following command

   ```shell
   docker restart ocnc_vm
   ```
3. If you mess up the virtual system and want to restart from zero, stop and remove the current container, 

   ```shell
   docker stop ocnc_vm
   docker rm ocnc_vm
   ```
   then initialize a new one
   
   (Mac/Linux)
   ```shell
   docker run -it -d -p 5901:5901 -p 6901:6901 -e  VNC_RESOLUTION=1360x768 -v $(pwd):/headless/Documents/Docker_shared --user 1984 --name ocnc_vm wchenoist/ocnc2017_software
   ```
   (Windows PowerShell)
   ```shell
   docker run -it -d -p 5901:5901 -p 6901:6901 -e  VNC_RESOLUTION=1360x768 -v ${pwd}:/headless/Documents/Docker_shared --user 1984 --name ocnc_vm wchenoist/ocnc2017_software
   ```
4. By default, the directory for initializing the docker container, e.g. `c:\docker_shared` (Windows) or `$HOME/docker_shared` (Mac/Linux), is mounted as `$HOME/Documents/Docker_shared` in the virtual system, anything put in this directory can be shared between the host and the virtual system.

5. Software with Python interfaces (NEURON, NEST, Brian, STEPS) can be accessed using Jupyter notebook, you can find it as well as other useful tools in Desktop->Applications. 

5. The size of the desktop is 1360x768. If you want to change this, change `VNC_RESOLUTION=1360x768` to whichever size you want. For 13-inch laptop, you can try `VNC_RESOLUTION=1250x590`.

