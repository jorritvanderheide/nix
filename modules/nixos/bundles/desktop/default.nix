{
  inputs,
  pkgs,
  ...
}: {
  # Nix
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  # Networking
  networking.networkmanager.enable = true;

  # Timezone
  time.timeZone = "Europe/Amsterdam";

  # Packages
  environment.systemPackages = with pkgs; [
    alejandra
    git
    home-manager
    nixd
  ];

  # Services
  services = {
    ## SSH
    openssh.enable = true;

    ## Power management
    power-profiles-daemon.enable = false;
    auto-cpufreq.enable = true;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Security
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
