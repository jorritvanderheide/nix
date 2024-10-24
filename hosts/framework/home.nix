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
    # Desktop environment
    gnome.enable = true;

    ## Features
    brave.enable = true;
    git = {
      enable = true;
      userName = "jorrit";
      userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    };

    ## Impermanence
    impermanence = {
      enable = true;
      directories = [
        # Data folders
        "Git"

        # Config folders
        ".config/BraveSoftware/Brave-Browser"
        ".config/Code"
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
        ".vscode"
      ];
    };
  };
}
