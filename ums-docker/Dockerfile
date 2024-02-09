# syntax=docker/dockerfile:1
FROM debian:stable AS base
ARG ums_version

ENV DEBIAN_FRONTEND noninteractive
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
RUN apt-get install --no-install-recommends -y bc procps expect

COPY setup-igel-ums-linux_${ums_version}.bin /root/
COPY unintended_ums_installation.sh /root/
RUN /root/unintended_ums_installation.sh /root/setup-igel-ums-linux_${ums_version}.bin
RUN rm -f /root/setup-igel-ums-linux_${ums_version}.bin
RUN rm -f /root/unintended_ums_installation.sh

FROM base AS ums-client
# Needed for Remote Console
RUN apt-get install --no-install-recommends -y libqt5core5a libxext6 libxrender1 libxtst6 libxi6

# Install latest node for better compatibility with greenfield
RUN apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash -
RUN apt-get install -y nodejs
RUN npm install --global yarn

# Needed for greenfield proxy
RUN apt-get install -y --no-install-recommends \
    libffi8 \
    libudev1 \
    libgbm1 \
    libgraphene-1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-gl \
    libosmesa6 \
    libdrm2 \
    libopengl0 \
    libglvnd0 \
    libglx0 \
    libglapi-mesa \
    libegl1-mesa \
    libglx-mesa0 \
    xwayland \
    xauth \
    xxd

RUN mkdir -p /var/run/compositor-proxy
RUN mkdir -p /opt/greenfield
WORKDIR /opt/greenfield

COPY ["client-entrypoint.sh", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

FROM base AS ums-server
COPY ["server-entrypoint.sh", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
