{config, ...}: {
  imports = [
    ./hardware.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "/dev/nvme0n1";
  };

  networking.hostName = "framework";

  users.users = {
    jorrit = {
      initialPassword = "10220408";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  system.stateVersion = "24.05";
}
