#! /bin/bash

docker exec zeeguu-api-core tail -f /var/log/apache2/error.log
