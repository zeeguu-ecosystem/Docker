# Zeeguu-Ecosystem

To clone this repository run the following:
```
git clone --recursive https://github.com/zeeguu-ecosystem/Docker
```

## Zeeguu container images

Prebuilt images are already available on [dockerhub](https://hub.docker.com/u/zeeguu).

### Building manually

To build the images, you need to have docker. Install it with:

```sh
sudo apt-get install docker.io -y
```

To build the zeeguu-mysql container image:
```sh
docker build -t zeeguu-mysql -f docker-files/zeeguu-mysql/Dockerfile .
```

To build the zeeguu-api-core container image:
```sh
docker build -t zeeguu-api-core -f docker-files/zeeguu-api-core/Dockerfile .
```

To build the zeeguu-web container image:
```sh
docker build -t zeeguu-web -f docker-files/zeeguu-web/Dockerfile .
```
