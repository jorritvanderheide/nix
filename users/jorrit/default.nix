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
    username = "jorrit";
    homeDirectory = "/home/jorrit";
    packages = with pkgs;
      [
        brave
        cascadia-code
        dbeaver-bin
        discord
        figlet
        figma-linux
        fzf
        git
        # gnome.dconf-editor
        gthumb
        inter
        meslo-lgs-nf
        obsidian
        roboto
        signal-desktop
        spotify
        teams-for-linux
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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
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
