{pkgs, ...}: {
  home.packages = with pkgs; [
    teams-for-linux
  ];

  myHomeManager.impermanence.directories = [
    ".config/teams-for-linux"
  ];
}
