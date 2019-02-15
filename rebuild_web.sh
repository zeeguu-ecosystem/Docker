#!/bin/bash
set -e

DEFAULT_INTERFACE=$(route | grep -m 1 -oP '^default.*\s+\K.*')
SERVER_IP=$(ifconfig $DEFAULT_INTERFACE | grep "inet " | awk '{print $2}')

# Set this to your server public IP if you have a different public IP than the one
# from the interface BUT MAKE SURE NOT TO COMMIT THIS ANYMORE ... MIGHT BE DIFFERENT
# FOR DIFFERENT PEOPLE... 
# SERVER_IP="zeeguu.org"

ZEEGUU_API__EXTERNAL="http://$SERVER_IP:9001"

docker build -t zeeguu-web-dev \
    --build-arg ZEEGUU_API__EXTERNAL="$ZEEGUU_API__EXTERNAL" \
    -f docker-files-dev/zeeguu-web/Dockerfile .
set +e
docker rm -f zeeguu-web-dev
set -e

# 
docker run --net=host -v ./Zeeguu-Reader/src/umr/static/news-icons:/var/www/static -d --name=zeeguu-web-dev zeeguu-web-dev
docker logs zeeguu-web-dev --follow
