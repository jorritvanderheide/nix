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
    home-manager
  ];

  # Services
  services = {
    ## SSH
    openssh.enable = true;

    ## Power management
    power-profiles-daemon.enable = false;
    auto-cpufreq.enable = true;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Security
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
