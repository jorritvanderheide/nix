{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.myHomeManager.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.persist-retro.nixosModules.home-manager.persist-retro
  ];

  options.myHomeManager.impermanence = {
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directories to persist";
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Files to persist";
    };
  };

  config = {
    home.persistence."/persist${config.home.homeDirectory}" = {
      allowOther = true;
      directories =
        [
          # Data folders
          "Desktop"
          "Documents"
          "Downloads"
          "Music"
          "Pictures"
          "Public"
          "Templates"
          "Videos"

          # Config folders
          ".gnupg"
          ".local/share/backgrounds"
          ".local/share/icc"
          ".local/share/keyrings"
          ".ssh"
        ]
        ++ cfg.directories;
      files =
        [
          # Config files
          ".screenrc"
        ]
        ++ cfg.files;
    };
  };
}
