{
  description = "A very basic flake";

  inputs = {
    # NixOS inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Community inputs
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    nixpkgs,
    self,
    ...
  } @ inputs: let
    lib = nixpkgs.lib // inputs.home-manager.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    outputs = self.outputs;
  in {
    nixosConfigurations = {
      framework = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./system.nix
        ];
      };
    };

    homeConfigurations = {
      "jorrit@framework" = lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
