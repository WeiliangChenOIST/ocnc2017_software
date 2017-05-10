docker stop ocnc_vm
docker rm ocnc_vm
docker build -t ocnc_vm .
docker run --rm -it -d -p 5901:5901 -p 6901:6901 -v $(pwd):/headless/Docker_shared --user 1984 --name ocnc_vm ocnc_vm
