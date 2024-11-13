{
  config,
  inputs,
  pkgs,
  ...
}: let
  diskoConfig = import ./disko.nix {device = "/dev/nvme0n1";};
in {
  imports = [
    diskoConfig
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
    ./hardware.nix
  ];

  # Boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  # Networking
  networking.hostName = "framework";

  # myNixOS config
  myNixOS = {
    ## Bundles
    bundles.desktop.enable = true;

    ### Users
    bundles.users.enable = true;
    home-users = {
      "jorrit" = {
        userConfig = ./users/jorrit;
        userSettings = {
          extraGroups = ["dialout" "docker" "networkmanager" "persist" "wheel"];
          hashedPasswordFile = config.age.secrets.jorrit.path;
        };
      };
    };

    ## Features
    docker.enable = true;
    gnome.enable = true;
    grub.enable = true;
    # hyprland.enable = true;
    impermanence.enable = true;
    logitech.enable = true;
    package-list.enable = true;

    ### Secrets
    agenix = {
      enable = true;
      secrets = {
        jorrit.file = ../../secrets/jorrit.age;
      };
    };
  };

  # Framework settings for fingerprint support
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

  system.stateVersion = "24.11";
}
