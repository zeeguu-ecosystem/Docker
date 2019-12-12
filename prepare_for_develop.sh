#! /bin/bash
set -x

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
docker run --net=host -d --name=zeeguu-web-dev \
       -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web \
       -v $(pwd)/Zeeguu-Exercises:/opt/Zeeguu-Exercises \
       -v $(pwd)/Zeeguu-Reader:/opt/Zeeguu-Reader \
       -v $(pwd)/Zeeguu-Teacher-Dashboard:/opt/Zeeguu-Teacher-Dashboard \
       -v $(pwd)/Zeeguu-Teacher-Dashboard-React:/opt/Zeeguu-Teacher-Dashboard-React \
       zeeguu-web

# Uninstalling anything that was "installed" and deploying versions with "develop" instead
docker exec zeeguu-api-core-dev python /opt/Zeeguu-Core/setup.py develop --uninstall
docker exec zeeguu-api-core-dev python /opt/Zeeguu-API/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Web/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Exercises/src/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Reader/src/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Teacher-Dashboard/src/setup.py develop --uninstall

# Install the npm packages for the NodeJS projects
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard && npm install"
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Exercises && npm install"
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Reader && npm install"


echo "After making local changes, make sure to run ./api_redeploy and ./web_redeploy "
