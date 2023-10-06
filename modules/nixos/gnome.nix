{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment = {
    systemPackages = (with pkgs;[
      gnome.gnome-tweaks
    ]) ++ (with pkgs.gnomeExtensions;[
      dash-to-dock
      captivate # cap button indicator
      appindicator # tray icon
    ]);

    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-text-editor
    ]) ++ (with pkgs.gnome; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      # geary # email reader
      evince # document viewer
      gedit # text editor
      gnome-contacts
      gnome-maps
      gnome-weather
      gnome-music
      gnome-characters
      # gnome-terminal
      hitori # sudoku game
      iagno # go game
      simple-scan
      totem # video player
      tali # poker game
      yelp # help viewer
    ]);
  };
}




