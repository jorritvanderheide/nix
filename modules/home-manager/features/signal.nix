{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop
  ];

  myHomeManager.impermanence.directories = [
    ".config/Signal"
  ];
}
