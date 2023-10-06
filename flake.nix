# Configuration file init by: nix flake init -t github:misterio77/nix-starter-config#standard
{
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      username = "alex";
      useremail = "reizero@live.com";
      hostname = "luna";
      libs = import ./libs { inherit nixpkgs; };
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = libs.forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        with builtins; lib.genAttrs (attrNames (readDir ./profiles))
          (profile:
            lib.nixosSystem
              {
                specialArgs = {
                  inherit self inputs outputs username useremail;
                  hostname = profile;
                };
                modules = [
                  ./profiles/${profile}
                ];
              }
          );

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # Or run 'nix build .#homeConfigurations.<username>.activationPackage' in none-nixos distro first
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "${username}" = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs username useremail;
            hyprland = inputs.hyprland;
          };
          modules = [
            # > Our main home-manager configuration file <
            ./home/desktop.nix

            # Ony non-nixos use home-manager standalone, use this config fixing issues.
            {
              targets.genericLinux.enable = true;
            }
          ];
        };
      };
    };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # The Nix User Repository
    # nur.url = github:nix-community/NUR;

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

}
