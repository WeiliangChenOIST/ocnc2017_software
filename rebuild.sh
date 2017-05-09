docker stop ocnc
docker rm ocnc
docker build -t ocnc .
docker run --rm -it -d -p 5901:5901 -p 6901:6901 -v $(pwd)/docker_shared:/headless/Documents/docker_shared --user 1984 --name ocnc ocnc
