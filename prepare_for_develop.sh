#! /bin/bash
set -x
ORIG_TEACHER_DASHBOARD_DIR=`grep -i "Alias /teacher-dashboard" ./docker-files/zeeguu-web/apache-zeeguu.conf | awk '{ print $3 }'`
NEW_TEACHER_DASHBOARD_DIR="/opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/build"

ORIG_WEB_DIR="/var/www/zeeguu-web"
NEW_WEB_DIR="/opt/Zeeguu-Web"

docker start zeeguu-mysql


docker stop zeeguu-web 2> /dev/null || echo "zeeguu-web container does not exist"
docker stop zeeguu-api-core 2> /dev/null || echo "zeeguu-api-core container does not exist"

docker rm -f zeeguu-web-dev > /dev/null 2>&1
docker rm -f zeeguu-api-core-dev > /dev/null 2>&1


# Running the containers with the locally mapped folders
docker run --net=host -d --name=zeeguu-api-core-dev \
        -v $(pwd)/Zeeguu-API/zeeguu_api:/opt/Zeeguu-API/zeeguu_api \
        -v $(pwd)/Zeeguu-Core/zeeguu_core:/opt/Zeeguu-Core/zeeguu_core \
        zeeguu-api-core
docker run --net=host -d --name=zeeguu-web-dev \
       -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web \
       -v $(pwd)/Zeeguu-Exercises/src:/opt/Zeeguu-Exercises/src \
       -v $(pwd)/Zeeguu-Reader/src:/opt/Zeeguu-Reader/src \
       -v $(pwd)/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/src:/opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/src \
       -v $(pwd)/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/package.json:/opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/package.json \
       zeeguu-web

# Uninstalling anything that was "installed" and deploying versions with "develop" instead
docker exec zeeguu-api-core-dev python /opt/Zeeguu-Core/setup.py develop --uninstall
docker exec zeeguu-api-core-dev python /opt/Zeeguu-API/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Web/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Exercises/src/setup.py develop --uninstall
docker exec zeeguu-web-dev python /opt/Zeeguu-Reader/src/setup.py develop --uninstall

#Start the python projects in develop mode
docker exec zeeguu-web-dev python /opt/Zeeguu-Web/setup.py develop
docker exec zeeguu-web-dev python /opt/Zeeguu-Exercises/src/setup.py develop
docker exec zeeguu-web-dev python /opt/Zeeguu-Reader/src/setup.py develop

# Install the npm packages for the NodeJS projects
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard && npm install --no-optional"
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Exercises && npm install"
docker exec zeeguu-web-dev bash -c "cd /opt/Zeeguu-Reader && npm install"

# Replace the directory of the Teacher Dashboard React project in the apache configuration
docker exec -d zeeguu-web-dev sed -i "s,$ORIG_TEACHER_DASHBOARD_DIR,$NEW_TEACHER_DASHBOARD_DIR,g" /etc/apache2/sites-available/apache-zeeguu.conf
docker exec -d zeeguu-web-dev sed -i "s,$ORIG_WEB_DIR,$NEW_WEB_DIR,g" /etc/apache2/sites-available/apache-zeeguu.conf

# Reload the apache config
docker exec zeeguu-api-core-dev service apache2 reload


echo "After making local changes, make sure to run ./api_redeploy and ./web_redeploy "
