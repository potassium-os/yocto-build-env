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
    screen \
    u-boot-tools \
    libncurses-dev \
    libssl-dev \
    libelf-dev \
    podman \
    buildah \
    skopeo


# setup builder user
RUN set -exu \
  && groupadd --gid 1000 builder \
  && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash builder \
  && usermod --add-subuids 100000-165535 --add-subgids 100000-165535 builder \
  && usermod -a -G sudo builder \
  && chown -R 1000:1000 /home/builder \
  && echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && mkdir -p /opt/workdir

RUN set -exu \
  && mkdir -p /home/builder/.config/containers

COPY ./containers.conf /etc/containers/containers.conf
COPY ./podman-containers.conf /home/builder/.config/containers/containers.conf

RUN set -exu \
  && chmod 644 /etc/containers/containers.conf

RUN set -exu \
  && mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers \
  && touch /var/lib/shared/overlay-images/images.lock \
  && touch /var/lib/shared/overlay-layers/layers.lock \
  && touch /var/lib/shared/vfs-images/images.lock \
  && touch /var/lib/shared/vfs-layers/layers.lock
  && chmod 4755 /usr/bin/newgidmap \
  && chmod 4755 /usr/bin/newuidmap

USER builder

WORKDIR /opt/workdir

ENV _CONTAINERS_USERNS_CONFIGURED=""

CMD /bin/bash
