#! /bin/bash
set -ex
if [ ! -e ~/linuxgsm.sh ]; then
    cp /linuxgsm.sh ~/linuxgsm.sh
fi
if [ -e /autoinstall.sh ]; then
    bash /autoinstall.sh
fi
if [ $# = 0 ]; then
    tail -f /dev/null
else
    $@
    tmux set -g status off && tmux attach 2> /dev/null
fi
