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
    gnome = {
      enable = true;
      backgroundPaths.light = "file:///home/jorrit/Pictures/Backgrounds/day.jpg";
      backgroundPaths.dark = "file:///home/jorrit/Pictures/Backgrounds/night.jpg";
    };

    ## Features
    brave.enable = true;
    impermanence.enable = true;
  };

  # Git
  programs.git = {
    userName = "jorrit";
    userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = ["/etc/nixos"];
    };
  };
}
