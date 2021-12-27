#! /bin/bash
set -ex
if [ ! -e ~/sdtdserver ]; then
    ./linuxgsm.sh sdtdserver &&\
    mkdir -p lgsm/config-lgsm/sdtdserver/ &&\
    ./sdtdserver skeleton
    # Alpha 20 is now stable version
    # echo 'branch="latest_experimental"' >> lgsm/config-lgsm/sdtdserver/sdtdserver.cfg &&\
    ./sdtdserver auto-install
    # exec ./sdtdserver start
    if [ ! -e ~/log/console/sdtdserver-console.log ]; then
        mkdir -p ~/log/console/
        touch ~/log/console/sdtdserver-console.log
    fi
fi
