{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.myHomeManager.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.myHomeManager.impermanence = {
    data.directories = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    data.files = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    cache.directories = lib.mkOption {
      default = [];
      description = ''
      '';
    };
    cache.files = lib.mkOption {
      default = [];
      description = ''
      '';
    };
  };

  config = {
    home.persistence."/persist/home" = {
      directories =
        [
          # User data directories
          "Desktop"
          "Documents"
          "Downloads"
          "Git"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"

          # User configuration directories
          ".ssh"
          ".local/share/keyrings"

          ".config/Code"
          ".config/discord"
          ".config/git"
          ".config/obsidian"
          ".config/Pinta"
          ".config/Postman"
          ".config/Signal"
          ".config/spotify"
          ".config/teams-for-linux"
          ".vscode"
        ]
        ++ cfg.directories;
      allowOther = true;
    };
  };
}
