{pkgs, ...}: {
  home.packages = with pkgs; [
    brave
  ];

  myHomeManager.impermanence.directories = [
    ".config/BraveSoftware/Brave-Browser"
  ];
}
