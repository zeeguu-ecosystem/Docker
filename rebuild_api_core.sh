#!/bin/bash
set -e

# WARNING: Make sure that once you've added API keys to this file, you don't commit it anymore. To do this you can run:

#   git update-index --assume-unchanged rebuild_api_core.sh

MICROSOFT_TRANSLATE_API_KEY=''
GOOGLE_TRANSLATE_API_KEY=''
WORDNIK_API_KEY=''

docker build -t zeeguu-api-core-dev -f docker-files-dev/zeeguu-api-core/Dockerfile .
set +e
docker rm -f zeeguu-api-core-dev
set -e
docker run --net=host -d \
    -e MICROSOFT_TRANSLATE_API_KEY="$MICROSOFT_TRANSLATE_API_KEY" \
    -e GOOGLE_TRANSLATE_API_KEY="$GOOGLE_TRANSLATE_API_KEY" \
    -e WORDNIK_API_KEY="$WORDNIK_API_KEY" \
    --name=zeeguu-api-core-dev \
    zeeguu-api-core-dev
docker logs zeeguu-api-core-dev --follow
