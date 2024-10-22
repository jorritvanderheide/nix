{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
    ./hardware.nix
  ];

  # Boot
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      systemd-boot.enable = false;
    };
  };

  # Networking
  networking.hostName = "framework";

  # myNixOS config
  myNixOS = {
    bundles.desktop.enable = true;
    bundles.users.enable = true;

    home-users = {
      "jorrit" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = ["adbusers" "libvirtd" "networkmanager" "persist" "plugdev" "wheel"];
        };
      };
    };

    impermanence = {
      enable = true;
      wipeRoot.enable = true;
    };
  };

  # Framework-specific services for fingerprint support
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
