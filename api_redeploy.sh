#! /bin/bash

# this works if both the Zeeguu-Core and the Zeeguu-API
# have been deployed with setup.py develop.
# corresponding lines int he docker-files/

# if it fails to run the docker command, it assumes that
# it might be called from the host machine, and thus 
# 
((echo "Trying to run with docker..." && docker exec zeeguu-api-core-dev service apache2 reload) \
	|| (echo "Trying to run with vagrant..." && vagrant ssh -- -t 'docker exec zeeguu-api-core-dev service apache2 reload')) && echo "Success."

