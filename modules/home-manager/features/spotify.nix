{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
  ];

  myHomeManager.impermanence.directories = [
    ".cache/spotify"
    ".config/spotify"
  ];
}
