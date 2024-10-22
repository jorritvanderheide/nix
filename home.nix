{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home.username = "jorrit";
  home.homeDirectory = "/home/jorrit";

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}
