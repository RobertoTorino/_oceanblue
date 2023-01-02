#!/bin/bash

URL=$"http://localhost:8888"
process_id=$!

docker stop oceanblue_app
echo "container stopped"
wait $process_id

docker rm oceanblue_app
wait $process_id
echo "container removed"

docker rmi alpine
wait $process_id

docker rmi oceanblue
wait $process_id
echo "alpine images removed"

docker build -t oceanblue:latest -f Dockerfile .
echo "new alpine image build"
wait $process_id

docker run -dt --name oceanblue_app -p 8888:80 oceanblue:latest
echo "running new container now"
wait $process_id

echo "Exit status: $?"
echo "all processes finished"

[[ -x $BROWSER ]] && exec "$BROWSER" "$URL"
path=$(which xdg-open || which gnome-open) && exec "$path" "$URL"
if open -Ra "Google Chrome"; then
  echo "opening application now"
  open -a "Google Chrome" "$URL"
else
  echo "no system browser installed"
fi
