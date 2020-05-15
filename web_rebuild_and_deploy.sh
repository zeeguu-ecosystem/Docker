docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="https://api.zeeguu.org" -f docker-files/zeeguu-web/Dockerfile . && docker rm -f zeeguu-web && docker run --net=host -v /etc/letsencrypt:/etc/letsencrypt -v /home/mlun/zeeguu-data:/opt/zeeguu-data -d --name=zeeguu-web zeeguu-web

