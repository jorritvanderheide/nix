{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-intel"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/76419f85-843d-4b84-994b-30d806ff8eef";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/76419f85-843d-4b84-994b-30d806ff8eef";
    fsType = "btrfs";
    options = ["subvol=persist"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/76419f85-843d-4b84-994b-30d806ff8eef";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/79af9a86-63e1-466c-906a-3086506b68cf";}
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
