{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    discord
  ];

  myHomeManager.impermanence.directories = [
    ".config/discord"
  ];
}
