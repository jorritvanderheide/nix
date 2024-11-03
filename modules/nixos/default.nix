{
  config,
  inputs,
  lib,
  myLib,
  ...
}: let
  cfg = config.myNixOS;
  # Taking all modules in ./features and adding enables to them
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };
      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);

  # Taking all module bundles in ./bundles and adding bundle.enables to them
  bundles =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };
      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myLib.filesIn ./bundles);
in {
  imports =
    [
      inputs.agenix.nixosModules.default
      inputs.disko.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ features
    ++ bundles;

  # Nix
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
      warn-dirty = false;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
