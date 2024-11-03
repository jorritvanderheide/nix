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
    hyprland.url = "github:hyprwm/Hyprland";
    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";
    stylix.url = "github:danth/stylix";
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
        "jorrit@framework" = mkHome "x86_64-linux" ./hosts/framework/users/jorrit;
      };

      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;
    };
}
