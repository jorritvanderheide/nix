{pkgs, ...}: {
  home.packages = with pkgs; [
    pinta
  ];

  myHomeManager.impermanence.directories = [
    ".config/Pinta"
  ];
}
