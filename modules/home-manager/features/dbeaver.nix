{pkgs, ...}: {
  home.packages = with pkgs; [
    dbeaver-bin
  ];

  myHomeManager.impermanence.directories = [
    ".local/share/DBeaverData"
  ];
}
