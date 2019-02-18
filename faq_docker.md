
# connect to api container's shell
sudo docker exec -it zeeguu-api-core bash

# rebuild and restart api core
sudo docker rm -f zeeguu-api-core
sudo docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .

# start mysql
sudo docker run --net=host -v /home/mlun/zeeguu_data/mysql:/var/lib/mysql -d --name=zeeguu-mysql zeeguu-mysql


# show error log in api
sudo docker exec zeeguu-api-core cat /var/log/apache2/error.log

#restart api
sudo docker rm -f zeeguu-api-core ; sudo docker run --net=host -v /home/mlun/zeeguu_data/config/fmd.cfg:/opt/fmd/dashboard.cfg -v /etc/letsencrypt:/etc/letsencrypt -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY  --name=zeeguu-api-core zeeguu-api-core


# recompile and redeploy api

sudo docker rm -f zeeguu-api-core ;  sudo docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile . && sudo docker run --net=host -d -e MICROSOFT_TRANSLATE_API_KEY=$MICROSOFT_TRANSLATE_API_KEY -e GOOGLE_TRANSLATE_API_KEY=$GOOGLE_TRANSLATE_API_KEY -e WORDNIK_API_KEY=$WORDNIK_API_KEY  --name=zeeguu-api-core zeeguu-api-core

#rebuild and redeploy Web
sudo docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="https://api.zeeguu.org" -f docker-files/zeeguu-web/Dockerfile . && sudo docker rm -f zeeguu-web ; sudo docker run --net=host -v /etc/letsencrypt:/etc/letsencrypt -d --name=zeeguu-web zeeguu-web

