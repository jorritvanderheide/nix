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
    programs.fish = {
      enable = true;
      interactiveShellInit = "";
      plugins =
        [
          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro;
          }
        ]
        ++ cfg.plugins;
      shellAliases = {} // cfg.shellAliases;
    };

    myHomeManager.impermanence.directories = [
      ".local/share/fish"
    ];
  };
}
