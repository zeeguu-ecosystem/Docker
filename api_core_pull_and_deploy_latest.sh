#!/bin/bash

git submodule update  --recursive --remote Zeeguu-API
git submodule update  --recursive --remote Zeeguu-Core


docker build --build-arg API_VERSION=`cat .git/modules/Zeeguu-API/HEAD` -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile . && docker rm -f zeeguu-api-core && docker run --net=host -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY -e MULTI_LANG_TRANSLATOR_AB_TESTING=$MULTI_LANG_TRANSLATOR_AB_TESTING  --name=zeeguu-api-core zeeguu-api-core

