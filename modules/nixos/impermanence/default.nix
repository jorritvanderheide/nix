#  _
# (_)_ __ ___  _ __   ___ _ __ _ __ ___   __ _ _ __   ___ _ __   ___ ___
# | | '_ ` _ \| '_ \ / _ \ '__| '_ ` _ \ / _` | '_ \ / _ \ '_ \ / __/ _ \
# | | | | | | | |_) |  __/ |  | | | | | | (_| | | | |  __/ | | | (_|  __/
# |_|_| |_| |_| .__/ \___|_|  |_| |_| |_|\__,_|_| |_|\___|_| |_|\___\___|
#             |_|
#
# System configuration for impermanence.
{
  config,
  lib,
  pkgs,
  ...
}: {
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/wireguard"
      "/etc/ssh"

      "/var/lib/bluetooth"
      "/var/lib/fprint"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
      {
        directory = "/var/lib/colord";
        user = "colord";
        group = "colord";
        mode = "u=rwx,g=rx,o=";
      }
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/alsa/asound.state"
      "/var/lib/cups/printers.conf"
    ];
    hideMounts = true;
  };

  # Setup sudo
  security.sudo = {
    wheelNeedsPassword = false;
  };

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

  # Temporary files and directories configuration
  systemd.services.adjustNixosConfigPermissions = {
    description = "Adjusting permissions for /persist/system/etc/nixos/ to allow group modifications";
    wantedBy = ["multi-user.target"];
    script = ''
      find /persist/system/etc/nixos/ -type d -exec chmod 0770 {} \;
      find /persist/system/etc/nixos/ -type f -exec chmod 0660 {} \;
      chown -R :persist /persist/system/etc/nixos/
    '';
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
  };
}
