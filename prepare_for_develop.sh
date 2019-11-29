#! /bin/bash

docker start zeeguu-mysql


docker stop zeeguu-web
docker stop zeeguu-api-core

docker rm -f zeeguu-web-dev > /dev/null 2>&1
docker rm -f zeeguu-api-core-dev > /dev/null 2>&1


# Running the containers with the locally mapped folders
docker run --net=host -d --name=zeeguu-api-core-dev \
        -v $(pwd)/Zeeguu-API/zeeguu_api:/opt/Zeeguu-API/zeeguu_api \
        -v $(pwd)/Zeeguu-Core/zeeguu_core:/opt/Zeeguu-Core/zeeguu_core \
        zeeguu-api-core
docker run --net=host -d --name=zeeguu-web-dev -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web zeeguu-web

# Uninstalling anything that was "installed" and deploying versions with "develop" instead
docker exec zeeguu-api-core-dev python /opt/Zeeguu-Core/setup.py develop --uninstall
docker exec zeeguu-api-core-dev python /opt/Zeeguu-API/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Web/setup.py develop --uninstall


echo "After making local changes, make sure to run ./api_redeploy and ./web_redeploy "
