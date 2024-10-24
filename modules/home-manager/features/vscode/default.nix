{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHomeManager.vscode;
in {
  options.myHomeManager.vscode = {
    extensions = lib.mkOption {
      default = [];
      description = "Extensions to intall";
    };
    userSettings = lib.mkOption {
      default = {};
      description = "User settings";
    };
  };

  config = {
    programs.vscode = {
      enable = true;

      # Extensions
      enableExtensionUpdateCheck = false;
      extensions = with pkgs;
        [
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.kamadorueda.alejandra
        ]
        ++ cfg.extensions;

      # Settings
      enableUpdateCheck = false;
      userSettings =
        {
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.suggestSmartCommit" = false;
          "window.menuBarVisibility" = "toggle";
        }
        // cfg.userSettings;
    };
  };
}
