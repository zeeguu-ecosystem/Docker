#! /bin/bash
set -x

ORIG_TEACHER_DASHBOARD_DIR=`grep -i "Alias /teacher-dashboard" ./docker-files/zeeguu-web/apache-zeeguu.conf | awk '{ print $3 }'`
NEW_TEACHER_DASHBOARD_DIR="/opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard/build"

docker restart zeeguu-web-dev

#Start the python projects in develop mode
docker exec zeeguu-web-dev python /opt/Zeeguu-Web/setup.py develop
docker exec zeeguu-web-dev python /opt/Zeeguu-Exercises/src/setup.py develop
docker exec zeeguu-web-dev python /opt/Zeeguu-Reader/src/setup.py develop
docker exec zeeguu-web-dev python /opt/Zeeguu-Teacher-Dashboard/src/setup.py develop

# Start the NodeJS projects in develop mode
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard && npm run start"
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Exercises && npm run dev"
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Reader && npm run dev"

# Replace the directory of the Teacher Dashboard React project in the apache configuration
docker exec -d zeeguu-web-dev sed -i "s,$ORIG_TEACHER_DASHBOARD_DIR,$NEW_TEACHER_DASHBOARD_DIR,g" /etc/apache2/sites-available/apache-zeeguu.conf
 
# Reload the apache config
docker exec zeeguu-api-core-dev service apache2 reload

echo "Web is now redeployed and local changes are reflected at www.zeeguu.local"
