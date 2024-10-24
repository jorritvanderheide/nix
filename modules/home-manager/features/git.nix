{
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.git;
in {
  options = {
    programs.git = {
      userName = mkOption {
        type = types.str;
        default = config.home.username;
        description = "The name to use for commits";
      };
      userEmail = mkOption {
        type = types.str;
        default = {
        };
        description = "The email to use for commits";
      };
      extraConfig = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra configuration options to pass to git";
      };
    };
  };

  config = {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig =
        {
          init.defaultBranch = "main";
          safe.directory = ["/etc/nixos"];
        }
        ++ cfg.extraConfig;
    };
  };
}
