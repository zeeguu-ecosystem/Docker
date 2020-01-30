#!/bin/bash
. set_api_keys.sh

docker rm -f zeeguu-api-core && docker run --restart=always --net=host -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY -e MULTI_LANG_TRANSLATOR_AB_TESTING=$MULTI_LANG_TRANSLATOR_AB_TESTING  --name=zeeguu-api-core zeeguu-api-core

curl https://api.zeeguu.org/available_languages
