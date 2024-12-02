{pkgs, ...}: {
  home.packages = with pkgs; [
    jetbrains-mono
    jetbrains.idea-community
  ];

  myHomeManager.impermanence.directories = [
    ".config/JetBrains"
    ".local/share/JetBrains"
  ];
}
