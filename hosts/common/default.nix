#
#   ___ ___  _ __ ___  _ __ ___   ___  _ __
#  / __/ _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \
# | (_| (_) | | | | | | | | | | | (_) | | | |
#  \___\___/|_| |_| |_|_| |_| |_|\___/|_| |_|
#
#
# Common host configuration for all systems.
{
  config,
  pkgs,
  ...
}: let
in {
  imports = [
  ];

  # End of configuration
  system.stateVersion = "24.05"; # Do not change or remove
}
