{
  description = "Jorrit's NixOS configuration";

  inputs = {
    # NixOS modules
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Community modules
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {...} @ inputs: let
    overlays = import ./overlays {inherit inputs;};
    myLib = import ./lib/myLib {inherit inputs overlays;};
  in
    with myLib; {
      # NixOS configurations
      nixosConfigurations = {
        framework = mkSystem "x86_64-linux" ./hosts/framework;
      };

      # Home-Manager configurations
      homeConfigurations = {
        "jorrit@framework" = mkHome "x86_64-linux" ./hosts/framework/home.nix;
      };

      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;
    };
}
