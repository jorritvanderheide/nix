{pkgs, ...}: {
  users.groups.plugdev = {};

  environment.systemPackages = with pkgs; [
    android-tools
    android-udev-rules
  ];
}
