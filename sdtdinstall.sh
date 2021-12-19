#! /bin/bash
set -ex
if [ ! -e ~/sdtdserver ]; then
    ./linuxgsm.sh sdtdserver &&\
    mkdir -p lgsm/config-lgsm/sdtdserver/ &&\
    ./sdtdserver skeleton
    echo 'branch="latest_experimental"' >> lgsm/config-lgsm/sdtdserver/sdtdserver.cfg &&\
    ./sdtdserver auto-install
    exec ./sdtdserver start
fi
