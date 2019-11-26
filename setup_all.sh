#!/bin/bash

# 
# Run this when deploying on a server
# When setting up development run ./setup_development.sh
#

set -x

CONFIG_VARS="config_vars.sh"
if [ ! -f $CONFIG_VARS ]; then	
	cp $CONFIG_VARS.default $CONFIG_VARS
	echo "Please edit $CONFIG_VARS to set up at least the ZEEGUU_API__EXTERNAL config option"
    exit
fi
source $CONFIG_VARS


ls config/ | grep default | while read cfgfilename; do
    new_cfgfilename=`echo ${cfgfilename} | sed s/.default//g`

    if [ ! -f config/$new_cfgfilename ]; then
    	cp -n config/$cfgfilename config/$new_cfgfilename
    fi
done

# Start MySQL server
./run_mysql.sh

cd Zeeguu-API
API_VERSION=`git log --format="%H" -n 1`
cd ..
# Build and run the API
docker build --build-arg API_VERSION="$API_VERSION" -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .
docker run --net=host -d \
    -e MICROSOFT_TRANSLATE_API_KEY="$MICROSOFT_TRANSLATE_API_KEY" \
    -e GOOGLE_TRANSLATE_API_KEY="$GOOGLE_TRANSLATE_API_KEY" \
    -e WORDNIK_API_KEY="$WORDNIK_API_KEY" \
    --name=zeeguu-api-core zeeguu-api-core

cp -n docker-files/zeeguu-web/apache-zeeguu.conf.default docker-files/zeeguu-web/apache-zeeguu.conf

# Build and run the Web UI
docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="$ZEEGUU_API_EXTERNAL" -f docker-files/zeeguu-web/Dockerfile .
docker run --net=host -d --name=zeeguu-web zeeguu-web

# Add a test RSS feed
# English
printf "http://rss.cnn.com/rss/edition_world.rss\nCNN World RSS Feed\ncnn.png\nCNN World RSS Feed for news\nen" | docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
# German
printf "http://newsfeed.zeit.de/sport/index\nGerman RSS Feed\ncnn.png\nGerman feed for sports\nde" | docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
docker exec -i zeeguu-api-core python /opt/Zeeguu-Core/tools/feed_retrieval.py


echo "Updating your etc/hosts with the api.zeeguu.local and www.zeeguu.local entries."
echo "You might be asked to provide your sudo password"
echo ""

grep -qF 'api.zeeguu.local' /etc/hosts || echo '127.0.0.1 api.zeeguu.local' | sudo tee -a /etc/hosts
grep -qF 'www.zeeguu.local' /etc/hosts || echo '127.0.0.1 www.zeeguu.local' | sudo tee -a /etc/hosts

echo ""
echo "To try out the api you can "
echo "    curl api.zeeguu.local/available_languages"
echo " "

echo "The website should be available at "
echo "    www.zeeguu.local"

