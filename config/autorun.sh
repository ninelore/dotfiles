#!/usr/bin/env bash

function run {
    if ! pgrep -f $1 ;
    then
        $@&
    fi
}

#### This file is for user programs!
## Place 'run *program* here'. One Program per line
## The function will only start programs that are not running yet
#run discord --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy
O
#run bitwarden-desktop
