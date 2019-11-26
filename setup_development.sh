#!/bin/bash

set -x

source setup_all.sh

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

