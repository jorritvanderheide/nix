{
  lib,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.default
  ];

  # Home
  home.username = "jorrit";
  home.homeDirectory = lib.mkDefault "/home/jorrit";

  # Packages
  home.packages = with pkgs; [
    ## Fonts
    cascadia-code
    inter
    jetbrains-mono

    ## CLI
    figlet

    ## Other
    android-tools
  ];

  # myHomeManager config
  myHomeManager = {
    ## Bundles
    bundles.cli.enable = true;

    ## Features
    brave.enable = true;
    cursor.enable = true;
    direnv.enable = true;
    discord.enable = true;
    fish.enable = true;
    kicad.enable = true;
    obsidian.enable = true;
    pinta.enable = true;
    postman.enable = true;
    signal.enable = true;
    spotify.enable = true;
    teams.enable = true;

    ### Git
    git = {
      enable = true;
      userName = "jorrit";
      userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    };

    ### Gnome
    gnome = {
      enable = true;
      backgroundPaths = {
        light = "file://${builtins.toPath ./backgrounds/light.jpg}";
        dark = "file://${builtins.toPath ./backgrounds/dark.jpg}";
      };
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
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        esbenp.prettier-vscode
        github.copilot
        github.copilot-chat
        zhuangtongfa.material-theme
      ];
      userSettings = {
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
      };
    };
  };
}
