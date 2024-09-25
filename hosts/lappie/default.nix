#  _                   _
# | | __ _ _ __  _ __ (_) ___
# | |/ _` | '_ \| '_ \| |/ _ \
# | | (_| | |_) | |_) | |  __/
# |_|\__,_| .__/| .__/|_|\___|
#         |_|   |_|
#
# Host configuration for Lappie.
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  diskoConfig = import ./disko.nix {device = "/dev/nvme0n1";};
in {
  imports = [
    diskoConfig
    inputs.agenix.nixosModules.age
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel

    ./hardware-configuration.nix
    ./../../modules/nixos/age.nix
    ./../../modules/nixos/impermanence.nix
    ./../../modules/nixos/security.nix
  ];

  # Nix daemon settings
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["flakes" "nix-command"];
  };

  # Boot configuration
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = false;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  # Timezone configuration
  time.timeZone = "Europe/Amsterdam";

  # Desktop environment
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

    # Power management
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
        PCIE_ASPM_ON_BAT = "powersupersave";
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
    agenix
    alejandra
    displaylink
    fish
    git
    home-manager
  ];

  # Setup SSH
  programs.ssh.startAgent = true;

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
  users.groups.persist = {};
  users.users."jorrit" = {
    extraGroups = ["docker" "libvirtd" "networkmanager" "persist" "plugdev" "wheel"];
    hashedPasswordFile = config.age.secrets.jorrit.path;
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
    description = "Adjusting permissions for /persist/system/etc/nixos/ to allow group modifications";
    wantedBy = ["multi-user.target"];
    script = ''
      find /persist/system/etc/nixos/ -type d -exec chmod 0770 {} \;
      find /persist/system/etc/nixos/ -type f -exec chmod 0660 {} \;
      chown -R :persist /persist/system/etc/nixos/
    '';
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };

  # Setup impermanence
  environment.persistence."/persist/system" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/fprint"
    ];
  };

  # Setup Android USB debugging
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
  '';

  # Setup docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # User management and home-manager configuration
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "jorrit" = import ../../users/jorrit/default.nix;
    };
  };

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}
