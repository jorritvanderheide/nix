{
  description = "A very basic flake";

  inputs = {
    # NixOS inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Community inputs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
