#!/bin/bash

docker ps | grep "zeeguu-api-core-test" >/dev/null
if [ $? -ne 0 ]; then
    echo "Zeeguu-API-Core container not found!"
    exit 1
fi

printf "http://rss.cnn.com/rss/edition_world.rss\nCNN World RSS Feed\ncnn.png\nCNN World RSS Feed for news\nen" | docker exec -i zeeguu-api-core-test python /opt/Zeeguu-API/tools/add_rssfeed.py
docker exec -i zeeguu-api-core-test python /opt/Zeeguu-Core/tools/feed_retrieval.py
