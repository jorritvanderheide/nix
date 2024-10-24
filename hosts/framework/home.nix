{
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [outputs.homeManagerModules.default];

  # Home
  home.username = "jorrit";
  home.homeDirectory = lib.mkDefault "/home/jorrit";

  # TODO: Add to home-manager modules
  home.packages = with pkgs; [
    # Apps
    discord
    inkscape
    obsidian
    pinta
    postman
    signal-desktop
    teams-for-linux
    vscode

    # Fonts
    cascadia-code
    inter

    # CLI
    figlet

    # Other
    android-tools
  ];

  # myHomeManager config
  myHomeManager = {
    # Features
    brave.enable = true;
    gnome.enable = true;

    ## Fish
    fish = {
      plugins = with pkgs; [
        fishPlugins.autopair
      ];
    };

    ## Git
    git = {
      enable = true;
      userName = "jorrit";
      userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    };

    ## VSCode
    vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.eamodio.gitlens
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
        vscode-extensions.mskelton.one-dark-theme
        vscode-extensions.zhuangtongfa.material-theme
      ];
      userSettings = {
        "workbench.colorTheme" = "One Dark";
      };
    };

    ## Impermanence
    impermanence = {
      enable = true;
      directories = [
        # Config folders
        ".config/discord"
        ".config/obsidian"
        ".config/Pinta"
        ".config/Postman"
        ".config/Signal"
        ".config/spotify"
        ".config/teams-for-linux"
        ".icons"
        ".pub-cache"
        ".themes"
      ];
    };
  };
}
