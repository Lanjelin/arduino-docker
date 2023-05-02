#!/bin/bash
if [ ! -f /userscript/script ]
then
  cp /app/unraid-install.sh /userscript/script
  sed -i -e "s/AD_NAME=arduino-docker/AD_NAME=$1/g" /userscript/script
  echo 'arduino-docker-helper' > /userscript/name
  echo 'Helper script for arduino-docker to allow USB hotswap to container' > /userscript/description
fi
