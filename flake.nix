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
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    # Overlays
    overlays = [agenix.overlays.default];

    # Defines packages for each system
    forEachSystem = configurePackages: lib.genAttrs (import systems) (system: configurePackages pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib pkgsFor;

    # NixOS configurations, specifying the hosts and their modules
    nixosConfigurations = {
      # Framework
      framework = lib.nixosSystem {
        pkgs = pkgsFor.x86_64-linux;
        modules = [
          ./hosts/common
          ./hosts/framework
        ];
        specialArgs = {inherit inputs;}; # Pass inputs as special arguments
      };
    };
  };
}
