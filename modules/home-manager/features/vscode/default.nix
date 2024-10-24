{
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.vscode;
in {
  options.myHomeManager.vscode = {
    extensions = lib.mkOption {
      type = lib.types.list;
      default = with pkgs; [];
      description = "Extensions to intall";
    };
  };

  config = {
    programs.vscode = {
      enable = true;

      # Extensions
      programs.vscode.extensions = with pkgs;
        [
          vscode-extensions.github.copilot
          vscode-extensions.github.copilot-chat
          vscode-extensions.jnoortheen.nix-ide
          vscode-extensions.kamadorueda.alejandra
          vscode-extensions.zhuangtongfa.material-theme
        ]
        ++ cfg.extensions;
    };
  };
}
