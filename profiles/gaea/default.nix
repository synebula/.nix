{ inputs, outputs, lib, pkgs, config, self, username, useremail, hostname, ... }:
let
  inherit (inputs) home-manager hyprland nixpkgs-unstable;
in
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./networking.nix
    "${self}/modules/nixos/core.nix"
    "${self}/modules/nixos/nvidia.nix"
    "${self}/modules/nixos/gnome.nix"
    "${self}/modules/nixos/hyprland.nix"
    "${self}/modules/nixos/user-group.nix"
    "${self}/modules/nixos/samba.nix"
    "${self}/modules/nixos/zfs.nix"
    "${self}/modules/nixos/adb.nix"

    "${self}/modules/nixos/virtualize/libvirtd"
    "${self}/modules/nixos/virtualize/android.nix"
    "${self}/modules/nixos/virtualize/docker.nix"

    "${self}/modules/nixos/fonts"

    home-manager.nixosModules.home-manager
    {
      # home-manager.useGlobalPkgs = true;
      # home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs outputs hostname username useremail hyprland;

        # enable unstable packages
        nixpkgs = nixpkgs-unstable;
        pkgs = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;

          # if you import pkgs, must specify overlays
          overlays = [
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.unstable-packages
            outputs.overlays.nur-packages
          ];
        };
      };
      home-manager.users."${username}" = import ../../home/desktop.nix;
    }
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    zfs.extraPools = [ "zroot" ];

    # Allow to modify store. It's dangerous!!
    readOnlyNixStore = true;
  };


  environment.systemPackages = with pkgs;[
    # audio control software
    pamixer
    ntfs3g
  ];

  # set hdmi audio default device
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraConfig = "set-card-profile 1 output:alsa_output.pci-0000_00_1f.3.hdmi-stereo";
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nixos-cn.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      outputs.overlays.nur-packages

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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
