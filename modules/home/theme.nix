{ pkgs, ... }:

{
  imports = [
  ];

  home = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = "capitaine-cursors";
    };
  };

  # gtk's theme settings, generate files: 
  #   1. ~/.gtkrc-2.0
  #   2. ~/.config/gtk-3.0/settings.ini
  #   3. ~/.config/gtk-4.0/settings.ini
  gtk = {
    enable = true;
    # cursorTheme = {
    #   package = pkgs.capitaine-cursors;
    #   name = "capitaine-cursors";
    #   size = 16;
    # };

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
      gtk-theme-name = "Adwaita-dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-cursor-theme-name = "capitaine-cursors";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
      gtk-theme-name = "Adwaita-dark";
      gtk-icon-theme-name = "Papirus-Dark";
      gtk-cursor-theme-name = "capitaine-cursors";
    };
  };
}
