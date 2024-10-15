#    _                 _ _
#   (_) ___  _ __ _ __(_) |_
#   | |/ _ \| '__| '__| | __|
#   | | (_) | |  | |  | | |_
#  _/ |\___/|_|  |_|  |_|\__|
# |__/
#
# User configuration for Jorrit.
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/impermanence.nix
    ../../modules/home-manager/keybindings.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home packages and extensions
  home = {
    username = "jorrit";
    homeDirectory = "/home/jorrit";
    packages = with pkgs;
      [
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

        # Hyprland
        kitty
      ]
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        blur-my-shell
        burn-my-windows
        caffeine
        clipboard-indicator
        dash-to-dock
        impatience
        mpris-label
        night-theme-switcher
      ]);
  };

  # Enable fontconfig
  fonts.fontconfig.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # Setup FZF
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Setup Git
  programs.git = {
    enable = true;
    userName = "jorrit";
    userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = ["/etc/nixos" "/persist/system/etc/nixos"];
    };
  };

  # Reload system on change
  systemd.user.startServices = "sd-switch";

  # End of configuration
  home.stateVersion = "24.05"; # Do not change or remove

  programs.home-manager.enable = true; # Enable home manager
}
