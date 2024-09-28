# syntax=docker/dockerfile:1
FROM debian:stable AS base
ARG ums_version

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=vt100

RUN apt-get update
RUN apt-get dist-upgrade -y --allow-downgrades
RUN apt-get install --no-install-recommends -y locales tzdata

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Needed for UMS installation
RUN apt-get install --no-install-recommends -y bc procps expect libqt5core5a wget 

COPY --chmod=0755 setup-igel-ums-linux_${ums_version}.bin /root/
COPY unintended_ums_installation.sh /root/
RUN /root/unintended_ums_installation.sh /root/setup-igel-ums-linux_${ums_version}.bin
RUN rm -f /root/setup-igel-ums-linux_${ums_version}.bin
RUN rm -f /root/unintended_ums_installation.sh

FROM base AS ums-client
# Needed for Remote Console
RUN apt-get install --no-install-recommends -y libxext6 libxrender1 libxtst6 libxi6

# Install xpra and xpra-html5 to stream console to html
RUN apt-get install --no-install-recommends -y python3-pip libxxhash-dev libvpx-dev pkg-config libx11-dev libxfixes-dev libxext-dev libxdamage-dev libxkbfile-dev libxrandr-dev build-essential libxtst-dev libwebp-dev libopenh264-dev libxcomposite-dev libxres-dev libgtk-3-dev python3-cairo-dev python-gi-dev liblz4-dev python3-dev xvfb libuinputplus-dev python3-uinput wget unzip
RUN pip --no-cache-dir install --break-system-packages xpra
RUN wget https://github.com/Xpra-org/xpra-html5/archive/refs/tags/v16.1.zip -O /tmp/xpra-html5.zip
RUN unzip /tmp/xpra-html5.zip -d /tmp/
RUN cd /tmp/xpra-html5-16.1 && ./setup.py install

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

COPY ["client-entrypoint.sh", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

FROM base AS ums-server

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

COPY ["server-entrypoint.sh", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
