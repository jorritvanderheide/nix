{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    brave
  ];

  myHomeManager.impermanence.cache.directories = [
    ".config/BraveSoftware/Brave-Browser"
  ];
}
