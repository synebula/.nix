{ config, lib, pkgs, ... }:

{
  imports = [
  ];
  programs = {
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        esbenp.prettier-vscode
        pkief.material-icon-theme
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        # {
        #   name = "aws-toolkit-vscode";
        #   publisher = "amazonwebservices";
        #   version = "1.9.0";
        #   sha256 = "erRg/C0qSrPg0cK2qmnULOnFGj/mVQTyBy5Kyj1ZfVw=";
        # }
      ];
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };

  home.file.".config/Code/User/keybindings.json" = {
    source = ./keybindings.json;
  };
}
