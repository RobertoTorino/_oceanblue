#!/bin/bash
# clean up docker

DIR="logs"
# if dir does not exists create it
if
  [ ! -d "$DIR" ]
then
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
fi

process_id=$!
DATE=$(date +"%Y-%m-%dT%H:%M:%S")

# output all console info to file
exec > >(tee -i logs/"$DATE"-image-build.log)
exec 2>&1

docker stop oceanblue-app
echo "container stopped"
wait $process_id

docker rm oceanblue-app
wait $process_id
echo "container removed"

docker rmi alpine
wait $process_id

docker rmi oceanblue
wait $process_id
echo "alpine images removed"

docker image prune -a -f
wait $process_id
echo "all non-active images removed"

docker system prune --volumes -f
wait $process_id
echo removed all stopped containers, all networks, all volumes, all dangling images, all build cache

# exit script after 10 seconds
sleep 10
kill -15 $PPID
