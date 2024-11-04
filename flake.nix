#      _                 _ _   _       _   _ _       ___  ____                     __ _
#     | | ___  _ __ _ __(_) |_( )___  | \ | (_)_  __/ _ \/ ___|    ___ ___  _ __  / _(_) __ _
#  _  | |/ _ \| '__| '__| | __|// __| |  \| | \ \/ / | | \___ \   / __/ _ \| '_ \| |_| |/ _` |
# | |_| | (_) | |  | |  | | |_  \__ \ | |\  | |>  <| |_| |___) | | (_| (_) | | | |  _| | (_| |
#  \___/ \___/|_|  |_|  |_|\__| |___/ |_| \_|_/_/\_\\___/|____/   \___\___/|_| |_|_| |_|\__, |
#                                                                                       |___/
#
{
  description = "Jorrit's NixOS config";

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

      # Modules
      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;
    };
}
