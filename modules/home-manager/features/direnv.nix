{...}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fish.enable = true;
  };

  myHomeManager.impermanence.directories = [
    ".local/share/direnv"
  ];
}
