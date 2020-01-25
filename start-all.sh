#!/bin/bash
export MICROSOFT_TRANSLATE_API_KEY=''
export GOOGLE_TRANSLATE_API_KEY=''
export WORDNIK_API_KEY=''
export MULTI_LANG_TRANSLATOR_AB_TESTING=42

docker rm -f zeeguu-mysql && docker run --restart=always --net=host -v /home/mlun/zeeguu-data/mysql:/var/lib/mysql -d --name=zeeguu-mysql zeeguu-mysql
docker rm -f fmd-mysql && docker run -v /home/mlun/zeeguu-data/fmd-mysql:/var/lib/mysql -p 3307:3306 -d --name=fmd-mysql fmd-mysql
docker rm -f zeeguu-api-core && docker run --restart=always --net=host -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY -e MULTI_LANG_TRANSLATOR_AB_TESTING=$MULTI_LANG_TRANSLATOR_AB_TESTING  --name=zeeguu-api-core zeeguu-api-core
docker rm -f zeeguu-web && docker run --restart=always --net=host -v /etc/letsencrypt:/etc/letsencrypt -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d --name=zeeguu-web zeeguu-web 
docker image prune -f
