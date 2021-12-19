FROM registry.access.redhat.com/ubi8/ubi:latest as LGSM-BASE

RUN echo "enabled=0" >> /etc/yum/pluginconf.d/subscription-manager.conf

RUN dnf install -y  curl jq vim-common unzip python3 wget xz zlib ncurses libstdc++.i686 iproute gzip xz bc binutils bzip2 cpio file hostname nmap-ncat diffutils procps-ng &&\
    dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/tmux-2.7-1.el8.x86_64.rpm &&\
    dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/expect-5.45.4-5.el8.x86_64.rpm &&\
    dnf install -y http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/telnet-0.17-76.el8.x86_64.rpm &&\
    dnf clean all


RUN useradd -d /home/lgsm -m lgsm &&\
    usermod -G tty lgsm

RUN wget https://linuxgsm.com/dl/linuxgsm.sh -O /linuxgsm.sh &&\
    chmod +x /linuxgsm.sh &&\
    chown lgsm:lgsm /linuxgsm.sh &&\
    cp /linuxgsm.sh /home/lgsm/ &&\
    chown -R lgsm:lgsm /home/lgsm

USER lgsm
WORKDIR /home/lgsm/

ENV HOME="/home/lgsm"

COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/home/lgsm" ]

ENTRYPOINT ["/entrypoint.sh" ]
