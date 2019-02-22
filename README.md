# Zeeguu-Ecosystem

To clone this repository run the following:
```
git clone --recursive https://github.com/zeeguu-ecosystem/Lineup
```

## Zeeguu container images

Prebuilt images for testing are already available on [dockerhub](https://hub.docker.com/u/zeeguu).

### Building manually

#### Dependencies:
Docker needs to be installed. Install it with:
```sh
sudo apt-get install docker.io -y
```

#### Building container images

The rest of the commands must be run from the Lineup folder:
```
cd Lineup
```

To build the zeeguu-mysql container image:
```sh
docker build -t zeeguu-mysql -f docker-files/zeeguu-mysql/Dockerfile .
```

To build the zeeguu-api-core container image:
```sh
docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .
```

Before building the zeeguu-web container image you must copy the [apache-zeeguu.conf.default](docker-files/zeeguu-api-core/apache-zeeguu-conf) to ``docker-files/zeeguu-api-core/apache-zeeguu.conf``
and modify it accordingly.

To build the zeeguu-web container image:
```sh
docker build -t zeeguu-web --build-arg ZEEGUU_API__EXTERNAL="http://1.1.1.1:9001"  -f docker-files/zeeguu-web/Dockerfile .
```
Make sure to replace ``1.1.1.1:9001`` with the url:port where your API can be reached from other clients.

To run the containers:
```sh
docker run --net=host -d --name=<container_name> <image_name>
```

Example:
```sh
docker run --net=host -d --name=zeeguu-mysql zeeguu-mysql
# Wait for a minute to allow the zeeguu mysql to complete initialization
# before starting Zeeguu API. You can check the status by running:
# docker logs zeeguu-mysql --follow
# If you see "mysqld: ready for connections" then you are ready to continue.
docker run --net=host -d --name=zeeguu-api-core zeeguu-api-core
docker run --net=host -d --name=zeeguu-web zeeguu-web
```

### Extra environment variables for containers

For ``zeeguu-api-core`` you need to define the following API keys:
- GOOGLE_TRANSLATE_API_KEY
- MICROSOFT_TRANSLATE_API_KEY
- WORDNIK_API_KEY

To pass the variable, add the ``-e`` flag to docker run command. Example:
```sh
docker run --net=host -d -e MICROSOFT_TRANSLATE_API_KEY='key' -e GOOGLE_TRANSLATE_API_KEY='key' -e WORDNIK_API_KEY='key'  --name=zeeguu-api-core zeeguu-api-core
```

### Storing MySQL data under a given directory on the system

To store the MySQL data under a given path, follow the steps:

1. Create the data directory on the host system (e.g. ``/opt/mysql_datadir``)

2. Add the ``-v`` option to the MySQL container:
```sh
docker run --net=host -v /opt/mysql_datadir:/var/lib/mysql -d --name=zeeguu-mysql zeeguu-mysql
```

### Adding articles for the reader

To add a new RSS feed for the reader, you have to run the following:
```sh
docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
```
Example:
```sh
$ docker exec -i zeeguu-api-core python /opt/Zeeguu-API/tools/add_rssfeed.py
ZEEGUU: Loaded Zeeguu-Core config from /opt/Zeeguu-Core/default_core.cfg
ZEEGUU: Linked model with: mysql://zeeguu_test:zeeguu_test@127.0.0.1/zeeguu_test
Feed url:  http://rss.cnn.com/rss/edition_world.rss
Found image url at: http://i2.cdn.turner.com/cnn/2015/images/09/24/cnn.digital.png
Feed seems healthy: 28 items found.
Feed name (Enter for: CNN.com - RSS Channel - World):  CNN World RSS Feed
= CNN World RSS Feed
Icon name to be found in resources folder (e.g. 20min.png):  cnn.png
= cnn.png
Description (Enter for: CNN.com delivers up-to-the-minute news and information on the latest top stories, weather, entertainment, politics and more.): CNN World RSS Feed for news
= CNN World RSS Feed for news
Language code (e.g. en): en
= en
Done:
CNN World RSS Feed
CNN World RSS Feed for news
1
http://rss.cnn.com/rss/edition_world.rss
https://zeeguu.unibe.ch/api/resources/cnn.png
```

To fetch the articles from the RSS feed, run the following:
```sh
docker exec -i zeeguu-api-core python /opt/Zeeguu-Core/tools/feed_retrieval.py
```
