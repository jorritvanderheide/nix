{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    xh
    lazygit
    lsd
    zoxide
  ];
}
