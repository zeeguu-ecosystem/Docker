#! /bin/bash

# this works if both the Zeeguu-Core and the Zeeguu-API
# have been deployed with setup.py develop.
# corresponding lines int he docker-files/

docker exec zeeguu-api-core-dev service apache2 reload 

