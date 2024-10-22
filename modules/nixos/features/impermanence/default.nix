{
  pkgs,
  lib,
  inputs,
  config,
  myLib,
  ...
}: let
  cfg = config.myNixOS.impermanence;
  cfg' = config;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    (myLib.extendModule {
      path = inputs.persist-retro.nixosModules.persist-retro;

      extraOptions = {
        extended.persist-retro.enable = lib.mkEnableOption "enable persist-retro";
      };

      configExtension = config: lib.mkIf cfg'.extended.persist-retro.enable config;
    })
  ];

  options.myNixOS.impermanence = {
    wipeRoot.enable = lib.mkEnableOption "Destroy /root on every boot";

    volumeGroup = lib.mkOption {
      default = "btrfs_vg";
      description = "Btrfs volume group name";
    };

    directories = lib.mkOption {
      default = [];
      description = "Directories to persist";
    };
  };

  config = {
    extended.persist-retro.enable = true;
    fileSystems."/persist".neededForBoot = true;
    programs.fuse.userAllowOther = true;

    environment.persistence = let
      persistentData = builtins.mapAttrs (name: user: {
        directories = config.home-manager.users."${name}".myHomeManager.impermanence.data.directories;
        files = config.home-manager.users."${name}".myHomeManager.impermanence.data.files;
      }) (config.myNixOS.home-users);
      persistentCache = builtins.mapAttrs (name: user: {
        directories = config.home-manager.users."${name}".myHomeManager.impermanence.cache.directories;
        files = config.home-manager.users."${name}".myHomeManager.impermanence.cache.files;
      }) (config.myNixOS.home-users);
    in {
      "/persist/userdata".users = persistentData;
      "/persist/usercache".users = persistentCache;
      "/persist/system" = {
        hideMounts = true;
        directories =
          [
            "/etc/NetworkManager/system-connections"
            "/etc/nixos"
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            {
              directory = "/var/lib/colord";
              user = "colord";
              group = "colord";
              mode = "u=rwx,g=rx,o=";
            }
          ]
          ++ cfg.directories;
        files = [
          "/etc/machine-id"
          "/var/lib/alsa/asound.state"
        ];
      };
    };

    boot.initrd.postDeviceCommands =
      lib.mkIf cfg.wipeRoot.enable
      (lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/${cfg.volumeGroup}/root /btrfs_tmp
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
      '');
  };
}
