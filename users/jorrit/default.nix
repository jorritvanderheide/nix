#    _                 _ _
#   (_) ___  _ __ _ __(_) |_
#   | |/ _ \| '__| '__| | __|
#   | | (_) | |  | |  | | |_
#  _/ |\___/|_|  |_|  |_|\__|
# |__/
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home-manager/impermanence.nix
    ../../modules/home-manager/gnome.nix
    ../../modules/home-manager/keybindings.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home packages and extensions
  home = {
    packages = with pkgs;
      [
        brave
        cascadia-code
        dynamic-wallpaper
        figlet
        figma-linux
        fzf
        git
        gnome.dconf-editor
        gnome.gnome-boxes
        gnome.gnome-tweaks
        inter
        nixpkgs-fmt
        obsidian
        roboto
        signal-desktop
        spotify
        vscode
        whatsapp-for-linux
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
  home.stateVersion = "24.05"; # No not change or remove
}
