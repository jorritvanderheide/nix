{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Eclude packages from Gnome
  environment.gnome.excludePackages = with pkgs; [
    baobab
    epiphany
    geary
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-connections
    gnome-console
    gnome-contacts
    gnome-maps
    gnome-music
    gnome-tour
    gnome-weather
    gnome-text-editor
    simple-scan
    totem
    xterm
    yelp
  ];
}
