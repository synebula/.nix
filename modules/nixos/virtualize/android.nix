{ config, pkgs, lib, ... }:
{
  virtualisation.waydroid.enable = true; # need dns port
  environment.systemPackages = [
    pkgs.waydroid-script
  ];
}
