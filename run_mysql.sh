#!/bin/sh

docker image ls | grep "^zeeguu-mysql " > /dev/null
if [ $? -ne 0 ]; then
    echo "Zeeguu-mysql container image not found, building the container image..."
    docker build -t zeeguu-mysql -f docker-files/zeeguu-mysql/Dockerfile . > /dev/null
fi

docker start zeeguu-mysql > /dev/null 2>&1
if [ $? -ne 0 ]; then
    docker run --net=host -d --name=zeeguu-mysql zeeguu-mysql
fi

docker logs zeeguu-mysql 2>&1 | grep "port: 3306  MySQL Community Server (GPL)" > /dev/null
while [ $? -ne 0 ]; do
    echo "Waiting for MySQL database to be ready..."
    sleep 1
    docker logs zeeguu-mysql 2>&1 | grep "port: 3306  MySQL Community Server (GPL)" > /dev/null
done

echo "MySQL database is ready!"
