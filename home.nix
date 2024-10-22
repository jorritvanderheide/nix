{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.username = "jorrit";
  home.homeDirectory = "/home/jorrit";

  # Enable home-manager
  programs.home-manager.enable = true;

  # Reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}
