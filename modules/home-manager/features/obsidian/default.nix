{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
  ];

  myHomeManager.impermanence.directories = [
    ".config/obsidian"
  ];
}
