{
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [outputs.homeManagerModules.default];

  # Home
  home.username = "jorrit";
  home.homeDirectory = lib.mkDefault "/home/jorrit";

  # Packages
  home.packages = with pkgs; [
    ## Fonts
    cascadia-code
    inter

    ## CLI
    figlet

    ## Other
    android-tools
  ];

  # myHomeManager config
  myHomeManager = {
    ## Features
    brave.enable = true;
    discord.enable = true;
    gnome.enable = true;
    obsidian.enable = true;
    pinta.enable = true;
    postman.enable = true;
    signal.enable = true;
    teams.enable = true;

    ### Fish
    fish = {
      enable = true;
      # plugins = [
      # ];
      # shellAliases = {
      #   "nrbs" = "sudo nixos-rebuild switch --flake /etc/nixos#framework";
      # };
    };

    ### Git
    git = {
      enable = true;
      userName = "jorrit";
      userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    };

    ### Impermanence
    impermanence = {
      enable = true;
      directories = [
        ".icons"
        ".pub-cache"
        ".themes"
      ];
    };

    ### VSCode
    vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.eamodio.gitlens
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat
        vscode-extensions.mskelton.one-dark-theme
        vscode-extensions.zhuangtongfa.material-theme
      ];
      userSettings = {
        "workbench.colorTheme" = "One Dark";
      };
    };
  };
}
