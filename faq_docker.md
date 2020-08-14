

# connect to container's shell
docker exec -it zeeguu-api-core bash
docker exec -it zeeguu-web bash

# rebuild and restart api core
docker rm -f zeeguu-api-core
docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .

# start mysql
docker run --net=host -v /home/mlun/zeeguu-data/mysql:/var/lib/mysql -d --name=zeeguu-mysql zeeguu-mysql

# start fmd-mysql
docker rm -f fmd-mysql && docker run -v /home/mlun/zeeguu-data/fmd-mysql:/var/lib/mysql -p 3307:3306 -d --name=fmd-mysql fmd-mysql


# Error Logs

## Live
docker exec zeeguu-web tail -f /var/log/apache2/error.log
docker exec zeeguu-api-core tail -f /var/log/apache2/error.log

## Cat
docker exec zeeguu-api-core cat /var/log/apache2/error.log


# recompile and redeploy api
# use --no-cache to force the build

docker build --build-arg API_VERSION=`cat .git/modules/Zeeguu-API/HEAD` -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile . && docker rm -f zeeguu-api-core && docker run --net=host -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY -e MULTI_LANG_TRANSLATOR_AB_TESTING=$MULTI_LANG_TRANSLATOR_AB_TESTING  --name=zeeguu-api-core zeeguu-api-core

#rebuild and redeploy Web
docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="https://api.zeeguu.org" -f docker-files/zeeguu-web/Dockerfile . && docker rm -f zeeguu-web && docker run --net=host -v /etc/letsencrypt:/etc/letsencrypt -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d --name=zeeguu-web zeeguu-web

# rebuild and redeploy Web 2.0
docker build -t zeeguu-web --build-arg ZEEGUU_API="https://api.zeeguu.org" -f docker-files/zeeguu-web-2.0/Dockerfile . && docker rm -f zeeguu-web && docker run --net=host -v /etc/letsencrypt:/etc/letsencrypt -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d --name=zeeguu-web zeeguu-web



### Other


# Check the container log

docker logs xxx


