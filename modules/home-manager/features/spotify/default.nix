{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    spotify
  ];

  myHomeManager.impermanence.directories = [
    ".config/spotify"
  ];
}
