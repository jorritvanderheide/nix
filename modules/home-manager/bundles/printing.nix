{pkgs, ...}: {
  home.packages = with pkgs; [
    bambu-studio
  ];

  myHomeManager.impermanence.directories = [
    ".config/BambuStudio"
  ];
}
