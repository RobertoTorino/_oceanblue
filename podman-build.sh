#!/bin/bash

DIR="logs"
# if dir does not exists create it
if
  [ ! -d "$DIR" ]
then
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
fi

URL1=$"http://localhost:8080"
URL2=$"http://localhost:9090/nginx-health"
process_id=$!
DATE=$(date +"%Y-%m-%dT%H:%M:%S")

# output all console info to file
exec > >(tee -i logs/"$DATE"-image-build.log)
exec 2>&1

podman stop oceanblue-pm-app
wait $process_id
echo "container stopped"

podman rm oceanblue-pm-app
wait $process_id
echo "container removed"

podman rmi alpine
wait $process_id

podman rmi oceanblue-pm
wait $process_id
echo "alpine images removed"

podman build -f Dockerfile.pm --format docker -t oceanblue-pm:latest .
wait $process_id
echo "new alpine image build"

podman run -dt --name oceanblue-pm-app -p 8080:80 -p 9090:90 oceanblue-pm:latest
wait $process_id
echo "running new container now"

podman start --all
wait $process_id
echo "starting all containers"

echo "Exit status: $?"
echo "all processes finished"

[[ -x $BROWSER ]] && exec "$BROWSER" "$URL1"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL1"
if open -Ra "Google Chrome" --args --incognito "$URL1"; then
  echo "opening application now"
  open -na "Google Chrome" --args --incognito "$URL1"
else
  echo "no system browser installed"
fi

[[ -x $BROWSER ]] && exec "$BROWSER" "$URL2"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL2"
if open -Ra "Google Chrome" --args --incognito "$URL2"; then
  echo "opening healthcheck now"
  open -na "Google Chrome" --args --incognito "$URL2"
else
  echo "no system browser installed"
fi

# exit script after 10 seconds
sleep 10
kill -15 $PPID
