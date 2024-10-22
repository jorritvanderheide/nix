{pkgs, ...}: {
  # Home
  home.username = "jorrit";
  home.homeDirectory = "/home/jorrit";

  # TODO: Add to home-manager modules
  home.packages = with pkgs; [
      # Apps
      brave
      dbeaver-bin
      discord
      figlet
      fzf
      gthumb
      inkscape
      obsidian
      pinta
      postman
      signal-desktop
      spotify
      teams-for-linux
      vscode

      # Fonts
      cascadia-code
      inter
      meslo-lgs-nf
      roboto

      # Other
      android-tools
    ];

  # myHomeManager config
  myHomeManager = {
    gnome = {
      backgroundPaths.light = "file:///home/jorrit/Pictures/Backgrounds/day.jpg";
      backgroundPaths.dark = "file:///home/jorrit/Pictures/Backgrounds/night.jpg";
    };

    ## Impermanence
    impermanence = {
      data.directories = [
        "Git"
      ];

      cache.directories = [
        ".config/BraveSoftware/Brave-Browser"
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
