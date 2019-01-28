#!/bin/bash
set -e

DEFAULT_INTERFACE=$(route | grep -m 1 -oP '^default.*\s+\K.*')
SERVER_IP=$(ifconfig $DEFAULT_INTERFACE | grep "inet " | awk '{print $2}')

# Set this to your server public IP if you have a different public IP than the one
# from the interface.
#SERVER_IP="1.1.1.1"

ZEEGUU_API__EXTERNAL="http://$SERVER_IP:9001"

docker build -t zeeguu-web-test \
    --build-arg ZEEGUU_API__EXTERNAL="$ZEEGUU_API__EXTERNAL" \
    -f docker-files-test/zeeguu-web/Dockerfile .
set +e
docker rm -f zeeguu-web-test
set -e
docker run --net=host -d --name=zeeguu-web-test zeeguu-web-test
docker logs zeeguu-web-test --follow
