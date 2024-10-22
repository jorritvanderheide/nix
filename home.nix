{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home = {
    username = "jorrit";
    homeDirectory = "/home/jorrit";

    persistence."/persist/home/jorrit" = {
      allowOther = true;
      directories = [
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

        # Configuration folders
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

        # Hidden folders
        ".ssh"
      ];
      files = [
        ".config/monitors.xml"
        ".screenrc"
      ];
    };

    stateVersion = "24.05";
  };

  # Programs configuration

  ## Git
  programs.git = {
    enable = true;
    userName = "jorrit";
    userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
