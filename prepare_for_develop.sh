#! /bin/bash

docker stop zeeguu-web 
docker rm -f zeeguu-web-with-volume

docker run --net=host -d --name=zeeguu-web-with-volume -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web zeeguu-web
docker exec zeeguu-web-with-volume python ./Zeeguu-Web/setup.py develop


docker start zeeguu-api-core
docker start zeeguu-mysql

echo "you can make changes to Zeeguu-Web locally now"