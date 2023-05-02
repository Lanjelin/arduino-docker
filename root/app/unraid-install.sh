#!/bin/bash

AD_NAME=arduino-docker

if [[ -f /etc/udev/rules.d/99-arduino-docker-tty.rules && -f /usr/local/bin/arduino-docker-tty.sh ]]
then
  # Both files exists, hopefully deletion was intended
  rm /etc/udev/rules.d/99-arduino-docker-tty.rules /usr/local/bin/arduino-docker-tty.sh

  # Reloadin rules
  udevadm control --reload-rules

  echo "Removed USB-hotswap for $AD_NAME"
else
  # Making helper script
  echo '#!/bin/bash' > /usr/local/bin/arduino-docker-tty.sh
  echo 'echo "Usb event: $1 $2 $3 $4" >> /tmp/arduino-docker-tty.log' >> /usr/local/bin/arduino-docker-tty.sh
  echo "if [ ! -z \"\$(docker ps -qf name=$AD_NAME)\" ]" >> /usr/local/bin/arduino-docker-tty.sh
  echo 'then' >> /usr/local/bin/arduino-docker-tty.sh
  echo '  if [ "$1" == "added" ]' >> /usr/local/bin/arduino-docker-tty.sh
  echo '  then' >> /usr/local/bin/arduino-docker-tty.sh
  echo "    docker exec -u 0 $AD_NAME mknod \$2 c \$3 \$4" >> /usr/local/bin/arduino-docker-tty.sh
  echo "    docker exec -u 0 $AD_NAME chmod -R 777 \$2" >> /usr/local/bin/arduino-docker-tty.sh
  echo '    echo "Adding $2 to arduino-docker" >> /tmp/arduino-docker-tty.log' >> /usr/local/bin/arduino-docker-tty.sh
  echo '  else' >> /usr/local/bin/arduino-docker-tty.sh
  echo "    docker exec -u 0 $AD_NAME rm \$2" >> /usr/local/bin/arduino-docker-tty.sh
  echo '   echo "Removing $2 from arduino-docker" >> /tmp/arduino-docker-tty.log' >> /usr/local/bin/arduino-docker-tty.sh
  echo '  fi' >> /usr/local/bin/arduino-docker-tty.sh
  echo 'fi' >> /usr/local/bin/arduino-docker-tty.sh

  # Making it executable
  chmod +x /usr/local/bin/arduino-docker-tty.sh

  # Adding rules
  echo "ACTION==\"add\", SUBSYSTEM==\"tty\", RUN+=\"/usr/local/bin/arduino-docker-tty.sh 'added' '%E{DEVNAME}' '%M' '%m'\"" > /etc/udev/rules.d/99-arduino-docker-tty.rules
  echo "ACTION==\"remove\", SUBSYSTEM==\"tty\", RUN+=\"/usr/local/bin/arduino-docker-tty.sh 'removed' '%E{DEVNAME}' '%M' '%m'\"" >> /etc/udev/rules.d/99-arduino-docker-tty.rules

  # Reloading rules
  udevadm control --reload-rules

  echo "Added USB-hotswap for $AD_NAME"
fi
