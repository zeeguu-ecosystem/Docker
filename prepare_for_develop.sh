#! /bin/bash

mkdir Zeeguu-Web/instance
chmod uog+wrx Zeeguu-Web/instance

docker stop zeeguu-web
docker run --net=host -d --name=zeeguu-web-with-volume -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web zeeguu-web

echo "you can make changes to Zeeguu-Web locally; then run 'redeploy_web.sh' to deploy"
