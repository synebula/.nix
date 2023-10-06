# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, username, useremail, ... }: {

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # Add stuff for your user as you see fit:
    packages = with pkgs; [
      nixpkgs-fmt
    ];
  };

  # Enable home-manager and git
  programs = {
    # home-manager.enable = true;
    # git.enable = true;

    git = {
      enable = true;

      userName = username;
      userEmail = useremail;

      includes = [
        {
          # use diffrent email & name for work
          path = "~/work/.gitconfig";
          condition = "gitdir:~/work/";
        }
      ];

      extraConfig = {
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
        pull.rebase = true;

        # replace https with ssh
        # url = {
        #   "ssh://git@github.com/" = {
        #     insteadOf = "https://github.com/";
        #   };
        #   "ssh://git@gitlab.com/" = {
        #     insteadOf = "https://gitlab.com/";
        #   };
        #   "ssh://git@bitbucket.com/" = {
        #     insteadOf = "https://bitbucket.com/";
        #   };
        # };
      };

    };
    
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = "";
      shellAliases = { };
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline ];
      settings = { ignorecase = true; };
      extraConfig = ''
        set mouse=a
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
      '';
    };
  };


  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
