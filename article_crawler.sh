#!/bin/bash

# used to use exec... but that runs in the existing image... probably better to start a new image... or?
#        && docker exec zeeguu-api-core python /opt/Zeeguu-Core/tools/article_crawler.py \

docker run -i --log-driver=none -a stdin -a stdout -a stderr --net=host zeeguu-api-core python /opt/Zeeguu-Core/tools/article_crawler.py --name article_crawler > /home/mlun/zeeguu-data/article_crawler_logs/`date --rfc-3339=seconds | sed s/\ /_/g` 2>&1

