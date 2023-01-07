#!/bin/bash

DIR="logs"
# if dir does not exists create it
if
  [ ! -d "$DIR" ]
then
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
fi

URL=$"http://localhost:9990"
process_id=$!
DATE=$(date +"%Y-%m-%dT%H:%M:%S")

# output all console info to file
exec > >(tee -i logs/"$DATE"-image-build.log)
exec 2>&1

podman stop oceanblue_app
echo "container stopped"
wait $process_id

podman rm oceanblue_app
wait $process_id
echo "container removed"

podman rmi alpine
wait $process_id

podman rmi oceanblue
wait $process_id
echo "alpine images removed"

podman build -f Dockerfile.pm --format docker -t oceanblue:latest .
echo "new alpine image build"
wait $process_id

podman run -dt --name oceanblue_app -p 9990:80 oceanblue:latest
echo "running new container now"
wait $process_id

echo "Exit status: $?"
echo "all processes finished"

[[ -x $BROWSER ]] && exec "$BROWSER" "$URL"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL"
if open -Ra "Google Chrome" --args --incognito "$URL"; then
  echo "opening application now"
  open -na "Google Chrome" --args --incognito "$URL"
else
  echo "no system browser installed"
fi

# exit script after 10 seconds
sleep 10
kill -15 $PPID
