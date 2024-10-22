{config, ...}: {
  imports = [
    ./hardware.nix
  ];

  # Nix
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["flakes" "nix-command"];
  };

  # Boot
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "/dev/nvme0n1";
  };

  # Timezone
  time.timeZone = "Europe/Amsterdam";

  # Networking
  networking.hostName = "framework";
  networking.networkmanager.enable = true;

  # Graphical services
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # System
  environment.systemPackages = with pkgs; [
    alejandra
    git

    # Apps
    brave
    dbeaver-bin
    discord
    figlet
    fzf
    gthumb
    inkscape
    obsidian
    pinta
    postman
    signal-desktop
    spotify
    teams-for-linux
    vscode

    # Fonts
    cascadia-code
    inter
    meslo-lgs-nf
    roboto

    # Other
    android-tools
  ];

  # Services
  services = {
    ## SSH
    openssh.enable = true;

    ## Printing
    printing.enable = true;
  };

  # Users
  users.users = {
    jorrit = {
      initialPassword = "10220408";
      isNormalUser = true;
      extraGroups = ["networkmanager" "persist" "wheel"];
    };
  };

  # Add user group
  users.groups.persist = {};

  # Temporary files
  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -"
    "d /persist/home/jorrit 0700 jorrit users -" # Add for users
  ];

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

  # Configure boot
  fileSystems."/persist".neededForBoot = true;

  # Setup persistence directories
  environment.persistence."/persist/system" = {
    hideMounts = true;
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
    ];
    files = [
      "/etc/machine-id"
      "/var/lib/alsa/asound.state"
      "/var/lib/cups/printers.conf"
    ];
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

  system.stateVersion = "24.05";
}
