{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS.home-users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        userConfig = lib.mkOption {
          default = ./../../home-manager/work.nix;
          description = "Path to the user's Home Manager configuration file.";
        };
        userSettings = lib.mkOption {
          default = {};
          description = "Additional user-specific settings.";
        };
      };
    });
    default = {};
    description = "Configuration for home users.";
  };

  config = {
    programs.fish.enable = true;

    home-manager = {
      extraSpecialArgs = {
        inherit inputs myLib;
        outputs = inputs.self.outputs;
      };

      users = builtins.mapAttrs (name: user: {
        imports = [
          (import user.userConfig)
          outputs.homeManagerModules.default
        ];
      }) (cfg.home-users);
    };

    users.users = builtins.mapAttrs (name: user: {
      isNormalUser = true;
      initialPassword = "10220408";
      description = "";
      extraGroups = ["libvirtd" "networkmanager" "wheel"];
      shell = pkgs.fish;
    }) (cfg.home-users);
  };
}
