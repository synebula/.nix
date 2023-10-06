{ config, lib, pkgs, ... }:

{
  imports = [
  ];

  home.packages = with pkgs; [
    v2ray
    v2raya
  ];
}