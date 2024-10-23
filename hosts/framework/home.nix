{ outputs, pkgs, ...}: {
  imports = [outputs.homeManagerModules.default];

  # Home
  home.username = "jorrit";
  home.homeDirectory = "/home/jorrit";

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

     brave.enable = true;
     git.enable = true;

    ## Impermanence
    impermanence = {
      data.directories = [
        "Git"
      ];

      cache.directories = [
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
      ];

     
      cache.files = [
        ".config/monitors.xml"
        ".screenrc"
      ];
    };
  };
}
