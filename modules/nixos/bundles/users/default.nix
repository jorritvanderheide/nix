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
          example = "DP-1";
        };
        userSettings = lib.mkOption {
          default = {};
          example = "{}";
        };
      };
    });
    default = {};
  };

  config = {
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
          initialPassword = "10220408";
          description = "";
          extraGroups = ["libvirtd" "networkmanager" "wheel"];
        }
        // user.userSettings
    ) (config.myNixOS.home-users);
  };
}
