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
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Extensions to intall";
    };
    userSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "User settings";
    };
  };

  config = {
    programs.vscode = {
      enable = true;

      # Extensions
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
        ]
        ++ cfg.extensions;

      # Settings
      enableUpdateCheck = false;
      userSettings =
        {
          # General settings
          "editor.formatOnSave" = true;
          "editor.minimap.enabled" = false;
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "git.suggestSmartCommit" = false;
          "window.menuBarVisibility" = "toggle";
          "window.titleBarStyle" = "custom";
          "workbench.startupEditor" = "none";

          # Nix settings
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = ["alejandra"];
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.framework.options";
                };
                "home-manager" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.jorrit.options";
                };
              };
            };
          };
        }
        // cfg.userSettings;
    };

    myHomeManager.impermanence.directories = [
      ".config/Code"
      ".vscode"
    ];
  };
}
