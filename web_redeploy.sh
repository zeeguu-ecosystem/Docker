#! /bin/bash
set -x

docker restart zeeguu-web-dev

# Start the NodeJS projects in develop mode
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Teacher-Dashboard-React/zeeguu-teacher-dashboard && npm run dev"
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Exercises && npm run dev"
docker exec -d zeeguu-web-dev bash -c "cd /opt/Zeeguu-Reader && npm run dev"

echo "Web is now redeployed and local changes are reflected at www.zeeguu.local"
