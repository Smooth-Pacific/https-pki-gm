export new_container=`docker ps | tail -1 | awk '{print $1}'`

# Connect to newest container
docker exec -it $new_container /bin/bash