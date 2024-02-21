FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

LABEL maintainer="lanjelin"

ENV TITLE="Arduino IDE"
ENV VERSION=2.3.2

COPY /root /

RUN \
  echo "**** install packages ****" && \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y \
    zip \
    wget \
    libnss3 \
    libsecret-1-0 && \
  echo "**** download arduino ide ****" && \
  wget -q https://github.com/arduino/arduino-ide/releases/download/${VERSION}/arduino-ide_${VERSION}_Linux_64bit.zip -O /app/arduino-ide_${VERSION}_Linux_64bit.zip && \
  unzip /app/arduino-ide_${VERSION}_Linux_64bit.zip -d /app/ && \
  cp -r /app/arduino-ide_${VERSION}_Linux_64bit/* /app && \
  echo "**** install extras ****" && \
  add-apt-repository ppa:mozillateam/ppa && \
  apt-get update && \
  apt install -y  --target-release 'o=LP-PPA-mozillateam' \
    firefox && \
  apt-get install -y \
    terminator \
    thunar && \
  sed -i 's|</applications>|  <application title="Arduino IDE" type="normal">\n    <maximized>no</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo 'Package: firefox*' >> /etc/apt/preferences.d/mozillateamppa && \
  echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozillateamppa && \
  echo 'Pin-Priority: 501' >> /etc/apt/preferences.d/mozillateamppa && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /app/arduino-ide_${VERSION}_Linux_64bit.zip \
    /app/arduino-ide_${VERSION}_Linux_64bit

# ports and volumes
EXPOSE 3000 3001

VOLUME /config
