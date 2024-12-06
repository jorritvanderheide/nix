{pkgs, ...}: {
  home.packages = with pkgs; [
    torrential
  ];
}
