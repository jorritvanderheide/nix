#                   __ _       
#   ___ ___  _ __  / _(_) __ _ 
#  / __/ _ \| '_ \| |_| |/ _` |
# | (_| (_) | | | |  _| | (_| |
#  \___\___/|_| |_|_| |_|\__, |
#                        |___/ 

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../modules/nixos/impermanence.nix
      ./../../modules/nixos/protonvpn.nix
      ./../../modules/nixos/security.nix
    ];

  boot = {
    blacklistedKernelModules = [
      "cros-usbpd-charger"
      "hid-sensor-hub"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "i915.enable_psr=1"
      "nvme.noacpi=1"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = true;
    };
  };

  # System-wide settings
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "flakes" "nix-command" ];
  };

  # Package management settings
  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
  };

  # Timezone configuration
  time.timeZone = "Europe/Amsterdam";

  # User management and home-manager configuration
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "jorrit" = import ./home-manager.nix;
    };
  };

  # Desktop environment and display manager settings

  # Gnome
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome = {
      enable = true;
    };
  };

  # System services configuration
  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    openssh.enable = true;
    printing.enable = true;
    protonvpn.enable = true;
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MAX_PERF_ON_BAT = 20;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };
  };

  # Power management configuration
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    fish
    fprintd
    wireguard-tools
  ];

  # Filesystem and permissions
  programs.fuse.userAllowOther = true;

  # Networking configuration
  networking = {
    hostName = "lappie";
    networkmanager.enable = true;
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };

  # User and group management
  users.groups.persist = { };
  users.users."jorrit" = {
    extraGroups = [ "networkmanager" "persist" "wheel" ];
    hashedPassword = "$y$j9T$ZYFriVsYqbMK11oWnQm3e0$vi2RkspRIpm1hOasZla1FZI99H1rKMLlOSsv5o/Rnp4";
    isNormalUser = true;
    shell = pkgs.fish;
  };

  # Adding systemd.tmpfiles.rules for /persist/home and /persist/home/<user>
  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -"
    "d /persist/home/jorrit 0700 jorrit users -"
  ];

  # Temporary files and directories configuration
  systemd.services.adjustNixosConfigPermissions = {
    description = "Adjust permissions for /persist/system/etc/nixos/ to allow group modifications";
    wantedBy = [ "multi-user.target" ];
    script = ''
      find /persist/system/etc/nixos/ -type d -exec chmod 0770 {} \;
      find /persist/system/etc/nixos/ -type f -exec chmod 0660 {} \;
      chown -R :persist /persist/system/etc/nixos/
    '';
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}

