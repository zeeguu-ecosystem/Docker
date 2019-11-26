#! /bin/bash

docker start zeeguu-mysql


docker stop zeeguu-web
docker rm -f zeeguu-web-dev > /dev/null 2>&1


docker run --net=host -d --name=zeeguu-web-dev -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web zeeguu-web
docker exec zeeguu-web-dev python ./Zeeguu-Web/setup.py develop


docker stop zeeguu-api-core
docker rm -f zeeguu-api-core-dev > /dev/null 2>&1

docker run --net=host -d --name=zeeguu-api-core-dev -v $(pwd)/Zeeguu-API:/opt/Zeeguu-API zeeguu-api-core
docker exec zeeguu-api-core-dev python ./Zeeguu-API/setup.py develop

echo "you can make changes to Zeeguu-Web & Zeeguu-API locally now"