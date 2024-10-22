{pkgs, ...}: {
  # Graphical services
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "Europe/Amsterdam";

  # Packages
  environment.systemPackages = with pkgs; [
    alejandra
    git
  ];

  # Services
  services = {
    ## SSH
    openssh.enable = true;

    ## Power management
    upower.enable = true;
  };

  # Security
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
