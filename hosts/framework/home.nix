{...}: {
  # Home
  home.username = "jorrit";
  home.homeDirectory = "/home/jorrit";

  # myHomeManager config
  myHomeManager = {
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
