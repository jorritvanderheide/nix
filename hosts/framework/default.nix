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
  pkgs,
  inputs,
  ...
}: let
  diskoConfig = import ./disko.nix {device = "/dev/nvme0n1";};
in {
  imports = [
    diskoConfig
    inputs.disko.nixosModules.default
    inputs.nixos-hardware.nixosModules.framework-13th-gen-intel

    ./hardware-configuration.nix
  ];

  # Framework specific services configuration
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

  # Set hostname
  networking = {
    hostName = "framework";
  };

  # Setup system-specific persist directories
  environment.persistence."/persist/system" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/fprint"
    ];
  };

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}
