{...}: {
  imports = [
    ./hardware.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "/dev/nvme0n1";
  };

  networking.hostName = "framework";

  system.stateVersion = "24.05";
}
