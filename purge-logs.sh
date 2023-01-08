#!/bin/bash
# clean up logs folder

rm -rvf logs
echo " logs folder cleaned and deleted!"

# exit script after 10 seconds
sleep 10
kill -15 $PPID
