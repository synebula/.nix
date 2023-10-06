{ config, lib, pkgs, hyprland, ... }:

{
  imports = [
    hyprland.homeManagerModules.default
    ./env.nix
  ];

  home.packages = with pkgs; [
    waybar # the status bar
    # hyprpaper # wallpaper
    swww # wallpaper
    dunst # notify
    rofi # app launcher
    kitty
    envsubst
    killall
    pavucontrol
    wlogout
  ];


  programs = {
    bash = {
      initExtra = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec  Hyprland
         fi
      '';
    };

    swaylock.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    enableNvidiaPatches = true;
    # extraConfig = builtins.readFile ./conf/hyprland.conf;
  };

  # hyprland configs, based on https://github.com/notwidow/hyprland
  home.file.".config/hypr" = {
    source = ./conf/hypr;
    # copy the scripts directory recursively
    recursive = true;
  };
  home.file.".config/hypr/themes/theme.conf".source = ./conf/hypr/themes/Catppuccin-Latte.conf;

  home.file.".config/rofi" = {
    source = ./conf/rofi;
    recursive = true;
  };
  home.file.".config/rofi/themes/theme.rasi".source = ./conf/rofi/themes/Catppuccin-Latte.rasi;

  home.file.".config/kitty" = {
    source = ./conf/kitty;
    recursive = true;
  };
  home.file.".config/kitty/themes/theme.conf".source = ./conf/kitty/themes/Catppuccin-Latte.conf;

  home.file.".config/swww" = {
    source = ./conf/swww;
    recursive = true;
  };

  home.file.".config/waybar" = {
    source = ./conf/waybar;
    recursive = true;
  };

  home.file.".config/wlogout" = {
    source = ./conf/wlogout;
    recursive = true;
  };
}
