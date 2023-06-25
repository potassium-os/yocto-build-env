FROM docker.io/debian:bookworm-slim

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
    util-linux

# install podman and friends
RUN set -exu \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/Debian_Testing/Release.key \
      | gpg --dearmor \
      | tee /etc/apt/keyrings/devel_kubic_libcontainers_stable.gpg > /dev/null \
    && echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/devel_kubic_libcontainers_stable.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/ /" \
      | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list > /dev/null \
    && apt-get -yq update \
    && apt-get -yq install podman buildah skopeo qemu-user-static

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
