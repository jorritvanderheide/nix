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
    self,
    nixpkgs,
    systems,
    home-manager,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = configurePackages: lib.genAttrs (import systems) (system: configurePackages pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;

    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
    };

    nixosConfigurations = {
      # Lappie
      lappie = lib.nixosSystem {
        modules = [
          ./hosts/lappie
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
