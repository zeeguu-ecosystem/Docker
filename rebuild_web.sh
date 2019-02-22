#!/bin/bash
source config_vars.sh

set -e

ZEEGUU_API__EXTERNAL="http://$SERVER_IP:9001"

docker build -t zeeguu-web-dev \
    --build-arg ZEEGUU_API__EXTERNAL="$ZEEGUU_API__EXTERNAL" \
    -f docker-files-dev/zeeguu-web/Dockerfile .
set +e
docker rm -f zeeguu-web-dev
set -e

docker run --net=host -v `pwd`/Zeeguu-Reader/src/umr/static/images/news-icons:/var/www/static -d --name=zeeguu-web-dev zeeguu-web-dev
docker logs zeeguu-web-dev --follow
