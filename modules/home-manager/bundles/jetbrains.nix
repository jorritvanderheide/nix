{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-mono
    jetbrains-toolbox
  ];

  myHomeManager.impermanence.directories = [
    ".config/jetbrains"
  ];
}
