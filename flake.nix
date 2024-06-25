#    ___  ___             __                
#  /'___\/\_ \           /\ \               
# /\ \__/\//\ \      __  \ \ \/'\      __   
# \ \ ,__\ \ \ \   /'__`\ \ \ , <    /'__`\ 
#  \ \ \_/  \_\ \_/\ \L\.\_\ \ \\`\ /\  __/ 
#   \ \_\   /\____\ \__/.\_\\ \_\ \_\ \____\
#    \/_/   \/____/\/__/\/_/ \/_/\/_/\/____/

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
  };

  outputs = { nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          # NixOS modules
          inputs.disko.nixosModules.default
          inputs.home-manager.nixosModules.default
          inputs.impermanence.nixosModules.impermanence

          # Host-specific modules
          ./hosts/lappie/configuration.nix
          (import ./hosts/lappie/disko.nix { device = "/dev/nvme0n1"; })
        ];
      };
    };
}
