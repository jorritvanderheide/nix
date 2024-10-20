#    _                 _ _
#   (_) ___  _ __ _ __(_) |_
#   | |/ _ \| '__| '__| | __|
#   | | (_) | |  | |  | | |_
#  _/ |\___/|_|  |_|  |_|\__|
# |__/
#
# User configuration for Jorrit.
{
  config,
  inputs,
  pkgs,
  ...
}: let
  backgroundPaths = {
    dark = "file:///home/jorrit/Pictures/Backgrounds/night.jpg";
    light = "file:///home/jorrit/Pictures/Backgrounds/day.jpg";
  };

  gnomeConfig = import ../../modules/home-manager/gnome {
    inherit config inputs pkgs backgroundPaths;
  };
in {
  imports = [
    # Modules
    gnomeConfig

    # Configurations
    ./impermanence.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home packages and extensions
  home = {
    username = "jorrit";
    homeDirectory = "/home/jorrit";
    packages = with pkgs; [
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
