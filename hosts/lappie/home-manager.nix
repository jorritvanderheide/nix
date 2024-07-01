#  _                          
# | |__   ___  _ __ ___   ___ 
# | '_ \ / _ \| '_ ` _ \ / _ \
# | | | | (_) | | | | | |  __/
# |_| |_|\___/|_| |_| |_|\___|

{ pkgs, inputs, ... }:

{
  imports = [
    # Home Manager modules
    ./../../modules/home-manager/impermanence.nix
    ./../../modules/home-manager/gnome.nix
    ./../../modules/home-manager/keybindings.nix
  ];

  # General settings
  nixpkgs.config.allowUnfree = true;

  # Home packages and extensions
  home = {
    packages = with pkgs; [
      brave
      cascadia-code
      dynamic-wallpaper
      figlet
      git
      gnome.dconf-editor
      gnome.gnome-terminal
      inter
      nixpkgs-fmt
      obsidian
      roboto
      signal-desktop
      spotify
      vscode
      whatsapp-for-linux
    ] ++ (with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      burn-my-windows
      caffeine
      clipboard-indicator
      dash-to-dock
      impatience
      mpris-label
      night-theme-switcher
      no-overview
    ]);
  };

  # Enable fontconfig
  fonts.fontconfig.enable = true;

  # Setup Git
  programs.git = {
    enable = true;
    userName = "jorrit";
    userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = [ "/etc/nixos" "/persist/system/etc/nixos" ];
    };
  };

  # Reload system on change
  systemd.user.startServices = "sd-switch";

  # End of configuration
  home.stateVersion = "24.05"; # No not change or remove
}
