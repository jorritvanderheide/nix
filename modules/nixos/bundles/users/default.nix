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
        inherit inputs;
        inherit myLib;
        outputs = inputs.self.outputs;
      };

      users =
        builtins.mapAttrs (name: user: {...}: {
          imports = [
            (import user.userConfig)
            outputs.homeManagerModules.default
          ];
        })
        (config.myNixOS.home-users);
    };

    users.users = builtins.mapAttrs (
      name: user:
        {
          isNormalUser = true;
          shell = pkgs.fish;
          extraGroups = ["libvirtd" "networkmanager" "wheel"];
        }
        // user.userSettings
    ) (config.myNixOS.home-users);
  };
}
