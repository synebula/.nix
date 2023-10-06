{ ... }:

{
  home = {
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "microsoft-edge";
      TERMINAL = "kitty";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_SCALE_FACTOR = "1";
      MOZ_ENABLE_WAYLAND = "1";
      # NIXOS_OZONE_WL = "1"; # for any ozone-based browser & electron apps to run on wayland


      _JAVA_AWT_WM_NONREPARENTING = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
      # 启用注释部分会导致NVIDIA下无法启动hyprland
      # WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      # WLR_EGL_NO_MODIFIRES = "1";
      WLR_NO_HARDWARE_CURSORS = "1"; # if no cursor,uncomment this line  
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      # WLR_RENDERER = "vulkan";
      # GBM_BACKEND = "nvidia-drm";
      CLUTTER_BACKEND = "wayland";
      # LIBVA_DRIVER_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __NV_PRIME_RENDER_OFFLOAD = "1";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
    };
    sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.local/bin"
    ];
  };
}
