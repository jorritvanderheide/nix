{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.myNixOS.impermanence;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.myNixOS.impermanence = {
    directories = lib.mkOption {
      default = [];
      description = "Directories to persist";
    };
    files = lib.mkOption {
      default = [];
      description = "Files to persist";
    };
  };

  config = {
    # Allow home-manager to modify user directories
    programs.fuse.userAllowOther = true;

    # Add user group
    users.groups.persist = {};

    # Configure boot
    fileSystems."/persist".neededForBoot = true;

    # Setup persistence directories
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories =
        [
          "/etc/NetworkManager/system-connections"
          "/etc/nixos"
          "/etc/wireguard"
          "/etc/ssh"
          "/var/lib/AccountsService"
          "/var/lib/bluetooth"
          "/var/lib/fprint"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/log"
        ]
        ++ cfg.directories;
      files =
        [
          "/etc/machine-id"
          "/var/lib/alsa/asound.state"
          "/var/lib/cups/printers.conf"
        ]
        ++ cfg.files;
    };

    # Configure sudo
    security.sudo.wheelNeedsPassword = false;

    # Wipe root on boot
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };
}
