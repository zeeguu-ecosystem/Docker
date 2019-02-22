#!/bin/bash

source config_vars.sh

set -e

# Start MySQL server
./run_mysql.sh

# Build and run the API
docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .
docker run --net=host -d \
    -e MICROSOFT_TRANSLATE_API_KEY="$MICROSOFT_TRANSLATE_API_KEY" \
    -e GOOGLE_TRANSLATE_API_KEY="$GOOGLE_TRANSLATE_API_KEY" \
    -e WORDNIK_API_KEY="$WORDNIK_API_KEY" \
    --name=zeeguu-api-core zeeguu-api-core

# Build and run the Web UI
docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="http://$SERVER_IP/api" -f docker-files/zeeguu-web/Dockerfile .
docker run --net=host -d --name=zeeguu-web zeeguu-web

# Add a test RSS feed
printf "http://rss.cnn.com/rss/edition_world.rss\nCNN World RSS Feed\ncnn.png\nCNN World RSS Feed for news\nen" | docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
docker exec -i zeeguu-api-core python /opt/Zeeguu-Core/tools/feed_retrieval.py
