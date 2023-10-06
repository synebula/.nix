#!/usr/bin/env bash

nixos-install \
--option substituters https://mirrors.ustc.edu.cn/nix-channels/store \
--no-root-passwd --flake .#$1