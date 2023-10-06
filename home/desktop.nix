# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, username, useremail, hyprland, ... }:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./core.nix
    ../modules/home/hyprland
    ../modules/home/vscode
    ../modules/home/v2ray
    ../modules/home/xdg.nix
    ../modules/home/theme.nix
  ];

  home = {
    # Add stuff for your user as you see fit:
    packages = with pkgs; [
      bc # GNU software calculator
      vlc
      imv
      motrix
      microsoft-edge
      telegram-desktop
      # firefox
      # chromium

      zip
      unzip
      lsof
      pciutils # lspci etc.
      steam-run
      frp
      obsidian
      wpsoffice-cn
      xorg.xhost

      dbeaver
      postman
      # jdk
      nodejs
      yarn
      flutter
      oraclejdk
      jetbrains.idea-community
      # nur.repos.linyinfeng.wemeet
    ];

    sessionVariables = {
      JAVA_HOME = "${pkgs.oraclejdk}";
      XIM = "fcitx";
      XIM_PROGRAM = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };

  programs = {
    bash = {
      initExtra = ''
        export XIM="fcitx"
        export XIM_PROGRAM="fcitx"
        export XMODIFIERS="@im=fcitx"
      '';
    };
  };


  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
    ];
  };

  # Enable home-manager and git
  programs = {
    home-manager.enable = true;
    # git.enable = true;
  };
}
