{
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.default
  ];

  # Home
  home.username = "jorrit";
  home.homeDirectory = lib.mkDefault "/home/jorrit";

  # Packages
  home.packages = with pkgs; [
    ## Fonts
    cascadia-code
    inter

    ## CLI
    figlet

    ## Other
    android-tools
  ];

  # myHomeManager config
  myHomeManager = {
    ## Bundles
    bundles.cli.enable = true;
    # bundles.meshtastic.enable = true;

    ## Features
    brave.enable = true;
    cursor.enable = true;
    direnv.enable = true;
    discord.enable = true;
    fish.enable = true;
    gnome.enable = true;
    # hyprland.enable = true;
    obsidian.enable = true;
    pinta.enable = true;
    postman.enable = true;
    signal.enable = true;
    spotify.enable = true;
    teams.enable = true;

    ### Git
    git = {
      enable = true;
      userName = "jorrit";
      userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    };

    ### Impermanence
    impermanence = {
      enable = true;
      directories = [
        ".icons"
        ".pub-cache"
        ".themes"
      ];
    };

    ### VSCode
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        eamodio.gitlens
        github.copilot
        github.copilot-chat
        zhuangtongfa.material-theme
      ];
      userSettings = {
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}
