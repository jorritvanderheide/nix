{pkgs, ...}: {
  home.packages = with pkgs; [
    code-cursor
  ];

  myHomeManager.impermanence.directories = [
    ".config/Cursor"
    ".cursor"
  ];
}
