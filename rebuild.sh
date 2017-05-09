docker stop ocnc
docker rm ocnc
docker build -t ocnc .
docker run -d -p 5901:5901 -p 6901:6901 --name ocnc ocnc
