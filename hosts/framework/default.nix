#   __                                             _
#  / _|_ __ __ _ _ __ ___   _____      _____  _ __| | __
# | |_| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ /
# |  _| | | (_| | | | | | |  __/\ V  V / (_) | |  |   <
# |_| |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\
#
#
# Host configuration for Framework.
{
  config,
  pkgs,
  inputs,
  ...
}: let
  diskoConfig = import ./disko.nix {device = "/dev/nvme0n1";};
in {
  imports = [
    # Modules
    diskoConfig
    inputs.disko.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel

    # Configurations
    ../../modules/nixos/power
    ./hardware.nix
  ];

  # Boot
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

  # Networking
  networking = {
    hostName = "framework";
  };

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

  # Packages
  environment.systemPackages = with pkgs; [
    displaylink
  ];

  # Services
  services = {
    fprintd.enable = true;
    fwupd.enable = true;
    fwupd.package =
      (import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
          sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
        }) {
          inherit (pkgs) system;
        })
      .fwupd;
  };

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}
