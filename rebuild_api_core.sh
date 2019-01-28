#!/bin/bash
set -e

MICROSOFT_TRANSLATE_API_KEY='key'
GOOGLE_TRANSLATE_API_KEY='key'
WORDNIK_API_KEY='key'

docker build -t zeeguu-api-core-test -f docker-files-test/zeeguu-api-core/Dockerfile .
set +e
docker rm -f zeeguu-api-core-test
set -e
docker run --net=host -d \
    -e MICROSOFT_TRANSLATE_API_KEY="$MICROSOFT_TRANSLATE_API_KEY" \
    -e GOOGLE_TRANSLATE_API_KEY="$GOOGLE_TRANSLATE_API_KEY" \
    -e WORDNIK_API_KEY="$WORDNIK_API_KEY" \
    --name=zeeguu-api-core-test \
    zeeguu-api-core-test
docker logs zeeguu-api-core-test --follow
