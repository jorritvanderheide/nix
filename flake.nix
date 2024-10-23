{
  description = "Jorrit's NixOS configuration";

  inputs = {
    # NixOS modules
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Community modules
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";
  };

  outputs = {...} @ inputs: let
    myLib = import ./lib/myLib/default.nix {inherit inputs;};
  in
    with myLib; {
      # NixOS configurations
      nixosConfigurations = {
        framework = mkSystem ./hosts/framework;
      };

      # Home-Manager configurations
      homeConfigurations = {
        "jorrit@framework" = mkHome "x86_64-linux" ./hosts/framework/home.nix;
      };

      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;
    };
}
