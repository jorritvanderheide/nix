#    ___  ___             __
#  /'___\/\_ \           /\ \
# /\ \__/\//\ \      __  \ \ \/'\      __
# \ \ ,__\ \ \ \   /'__`\ \ \ , <    /'__`\
#  \ \ \_/  \_\ \_/\ \L\.\_\ \ \\`\ /\  __/
#   \ \_\   /\____\ \__/.\_\\ \_\ \_\ \____\
#    \/_/   \/____/\/__/\/_/ \/_/\/_/\/____/
#
# Jorrit's NixOS config
{
  description = "Jorrit's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-hardware = {
      url = "github:nixos/nixos-hardware";
    };
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    home-manager,
    nixos-hardware,
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs; # Inherit outputs for easy reference in the rest of the flake
    lib = nixpkgs.lib // home-manager.lib; # Merge libraries from nixpkgs and home-manager

    overlays = [agenix.overlays.default]; # Overlays for agenix

    # Function to apply configurations across supported systems
    forEachSystem = configurePackages: lib.genAttrs (import systems) (system: configurePackages pkgsFor.${system});

    # Defines packages for each system
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system overlays; # Inherit system and overlays, allowing pkgsFor to be used as a package set
          config.allowUnfree = true; # Allow unfree packages
        }
    );
  in {
    inherit lib pkgsFor; # Make lib globally available

    # NixOS configurations, specifying the hosts and their modules
    nixosConfigurations = {
      # Lappie
      lappie = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          ./hosts/lappie # Import the configuration for Lappie
        ];
        specialArgs = {inherit inputs;}; # Pass inputs as special arguments
      };
    };
  };
}
