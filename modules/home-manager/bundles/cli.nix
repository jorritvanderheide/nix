{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    xh
    lazygit
    lsd
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
