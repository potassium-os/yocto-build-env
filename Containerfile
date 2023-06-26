FROM docker.io/debian:bullseye-slim

RUN set -exu \
  && apt-get -yq update \
  && apt-get -yq install \
    locales

# setup locale
RUN set -exu \
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# install some packages
RUN set -exu \
  && apt-get -yq update \
  && apt-get -yq install \
    build-essential \
    gcc \
    gpp \
    rsync \
    gdisk \
    fdisk \
    dosfstools \
    mtools \
    bison \
    flex \
    zsh \
    git \
    curl \
    wget \
    parted \
    gdisk \
    lz4 \
    bc \
    bash \
    gpg \
    sudo \
    chrpath \
    cpio \
    diffstat \
    file \
    gawk \
    zutils \
    zstd \
    python3 \
    python3-distutils \
    util-linux \
    qemu-user-static \
    ifupdown \
    iproute2 \
    screen


# setup builder user
RUN set -exu \
  && groupadd --gid 1000 builder \
  && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash builder \
  && usermod -a -G sudo builder \
  && chown -R 1000:1000 /home/builder \
  && echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo root:10000:5000 > /etc/subuid \
  && echo root:10000:5000 > /etc/subgid \
  && echo builder:20000:5000 > /etc/subuid \
  && echo builder:20000:5000 > /etc/subgid \
  && mkdir -p /opt/workdir

USER builder

WORKDIR /opt/workdir

CMD /bin/bash
