#    ___  ___             __
#  /'___\/\_ \           /\ \
# /\ \__/\//\ \      __  \ \ \/'\      __
# \ \ ,__\ \ \ \   /'__`\ \ \ , <    /'__`\
#  \ \ \_/  \_\ \_/\ \L\.\_\ \ \\`\ /\  __/
#   \ \_\   /\____\ \__/.\_\\ \_\ \_\ \____\
#    \/_/   \/____/\/__/\/_/ \/_/\/_/\/____/
{
  description = "My Nix Config";

  inputs = {
    # External dependencies this flake depends on
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

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
    # Defines the outputs of the flake
    self,
    nixpkgs,
    systems,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs; # Inherit outputs for easy reference
    lib = nixpkgs.lib // home-manager.lib; # Merge libraries from nixpkgs and home-manager

    # Function to apply configurations across supported systems
    forEachSystem = configurePackages: lib.genAttrs (import systems) (system: configurePackages pkgsFor.${system});

    # Defines packages for each system
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true; # Allow unfree packages
        }
    );
  in {
    inherit lib; # Make lib globally available

    # Nix daemon settings, enabling optimizations and experimental features
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
    };

    # NixOS configurations, specifying system-specific modules
    nixosConfigurations = {
      # Lappie
      lappie = lib.nixosSystem {
        modules = [
          ./hosts/lappie
        ];
        specialArgs = {inherit inputs;}; # Pass inputs as special arguments
      };
    };
  };
}
