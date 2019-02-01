#!/bin/bash
set -e

MICROSOFT_TRANSLATE_API_KEY='21281d0d5499487991f92351336da60b'
GOOGLE_TRANSLATE_API_KEY='AIzaSyDCH0ikA5fzQiOaMlWzWi7HHY080-wZNqE'
WORDNIK_API_KEY='b9588ee867984b055b14812a40f071e15a19e01d2e6362e15'

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
