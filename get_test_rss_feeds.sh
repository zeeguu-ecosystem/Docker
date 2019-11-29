#!/bin/bash

# Add a test RSS feed
# English
printf "http://rss.cnn.com/rss/edition_world.rss\nCNN World RSS Feed\ncnn.png\nCNN World RSS Feed for news\nen" | docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
# German
printf "http://newsfeed.zeit.de/sport/index\nGerman RSS Feed\ncnn.png\nGerman feed for sports\nde" | docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py

# Retrieve the stuff
docker exec -i zeeguu-api-core python /opt/Zeeguu-Core/tools/feed_retrieval.py
