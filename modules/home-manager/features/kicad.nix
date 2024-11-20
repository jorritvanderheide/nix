{pkgs, ...}: {
  home.packages = with pkgs; [
    kicad
  ];

  myHomeManager.impermanence.directories = [
    ".config/kicad"
  ];
}
