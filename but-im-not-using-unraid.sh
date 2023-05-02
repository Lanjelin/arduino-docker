#!/bin/bash

# Remaking autostart without unraid specific items
echo '#!/bin/bash' > root/defaults/autostart2
echo '/app/arduino-ide' >> root/defaults/autostart2

# Fetcing the helper script to current dir
cp root/app/unraid-install.sh ./usb-hotswap-helper.sh
