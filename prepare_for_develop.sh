#! /bin/bash
DIR="Zeeguu-Web/instance"

if ! [[ -d "$DIR" ]]; then
    echo "Folder $DIR doesn't exist, creating it"
    mkdir "$DIR"
fi
chmod uog+wrx Zeeguu-Web/instance

docker stop zeeguu-web
docker run --net=host -d --name=zeeguu-web-with-volume -v $(pwd)/Zeeguu-Web:/opt/Zeeguu-Web zeeguu-web
docker exec zeeguu-web-with-volume python ./Zeeguu-Web/setup.py develop

echo "you can make changes to Zeeguu-Web locally now"

