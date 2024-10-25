{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHomeManager.fish;
in {
  options.myHomeManager.fish = {
    plugins = lib.mkOption {
      default = [];
      description = "List of plugins";
    };
    shellAliases = lib.mkOption {
      default = {};
      description = "Shell aliases";
    };
  };

  config = {
    home.packages = with pkgs; [
      fishPlugins.autopair
      fishPlugins.hydro
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
      plugins =
        [
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair;
          }
          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro;
          }
        ]
        ++ cfg.plugins;
      shellAliases =
        {
          "nrs" = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
        }
        // cfg.shellAliases;
    };
  };
}
