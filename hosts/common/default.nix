#
#   ___ ___  _ __ ___  _ __ ___   ___  _ __
#  / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \
# | (_| (_) | | | | | | | | | | | (_) | | | |
#  \___\___/|_| |_| |_|_| |_| |_|\___/|_| |_|
#
#
# Common host configuration.
{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  imports = [
    # Modules
    inputs.agenix.nixosModules.age
    inputs.home-manager.nixosModules.default
    inputs.impermanence.nixosModules.impermanence

    # Configurations
    ./../../modules/nixos/age
    ./../../modules/nixos/impermanence
  ];

  # Nix daemon settings
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["flakes" "nix-command"];
  };

  # Timezone configuration
  time.timeZone = "Europe/Amsterdam";

  # Networking configuration
  networking = {
    networkmanager.enable = true;
  };

  # Graphical services
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    agenix
    alejandra
    displaylink
    git
    home-manager
  ];

  # Programs
  programs = {
    # SSH
    ssh.startAgent = true;

    # Fish
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    # Filesystem and permissions
    # fuse.userAllowOther = true;
  };

  # Services
  services = {
    # SSH
    openssh.enable = true;

    # Printing
    printing.enable = true;
  };

  # Adding systemd.tmpfiles.rules for /persist/home and /persist/home/<user>
  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -"
    "d /persist/home/jorrit 0700 jorrit users -"
  ];

  # Virtualization
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Setup Android USB debugging
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
  '';

  # User and group management
  users.groups.persist = {};
  users.users."jorrit" = {
    extraGroups = ["docker" "libvirtd" "networkmanager" "persist" "plugdev" "wheel"];
    hashedPasswordFile = config.age.secrets.jorrit.path;
    isNormalUser = true;
    shell = pkgs.fish;
  };

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}
