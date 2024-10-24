{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist/home/jorrit" = {
    allowOther = true;
    directories = [
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

      # User folders
      "Desktop"
      "Documents"
      "Downloads"
      "Git"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"

      # Hidden folders
      ".icons"
      ".pub-cache"
      ".ssh"
      ".themes"
    ];
    files = [
      ".config/monitors.xml"
      ".screenrc"
    ];
  };
}
