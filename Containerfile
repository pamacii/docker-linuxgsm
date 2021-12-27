FROM registry.access.redhat.com/ubi8/ubi:latest

# add stream sources
COPY ./*.repo /etc/yum.repos.d/

# install packages from ubi and centos stream repos
RUN echo "enabled=0" >> /etc/yum/pluginconf.d/subscription-manager.conf && \
    dnf upgrade-minimal --nobest --nodocs && \
    dnf clean all && \
    rm -rf /var/cache/dnf/*

RUN dnf install --nobest --nodocs --assumeyes --setopt=install_weak_deps=False \
        bc \
        binutils \
        bzip2 \
        cpio \
        curl \
        diffutils \
        file \
        gzip \
        hostname \
        iproute \
        jq \
        libstdc++.i686  \
        ncurses  \
        nmap-ncat  \
        procps-ng  \
        python3  \
        unzip \
        vim-common \
        wget  \
        xz  \
        zlib  \
      && \
    dnf --enablerepo="stream-*" install --nobest --nodocs --assumeyes --setopt=install_weak_deps=False \
        expect telnet tmux && \
    dnf clean all && \
    rm -rf /var/cache/dnf/*

RUN useradd -d /home/lgsm -m lgsm &&\
    usermod -G tty lgsm

COPY linuxgsm.sh /linuxgsm.sh
RUN chmod +x /linuxgsm.sh &&\
    chown lgsm:lgsm /linuxgsm.sh &&\
    chown -R lgsm:lgsm /home/lgsm
# RUN wget https://linuxgsm.com/dl/linuxgsm.sh -O /linuxgsm.sh &&\
#     chmod +x /linuxgsm.sh &&\
#     chown lgsm:lgsm /linuxgsm.sh &&\
#     cp /linuxgsm.sh /home/lgsm/ &&\
#     chown -R lgsm:lgsm /home/lgsm

USER lgsm
WORKDIR /home/lgsm/

ENV HOME="/home/lgsm"

COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/home/lgsm" ]

ENTRYPOINT ["/entrypoint.sh" ]
