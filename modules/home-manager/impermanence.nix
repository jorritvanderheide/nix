#  _                                                                     
# (_)_ __ ___  _ __   ___ _ __ _ __ ___   __ _ _ __   ___ _ __   ___ ___ 
# | | '_ ` _ \| '_ \ / _ \ '__| '_ ` _ \ / _` | '_ \ / _ \ '_ \ / __/ _ \
# | | | | | | | |_) |  __/ |  | | | | | | (_| | | | |  __/ | | | (_|  __/
# |_|_| |_| |_| .__/ \___|_|  |_| |_| |_|\__,_|_| |_|\___|_| |_|\___\___|
#             |_|                                                        

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # NixOS modules
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist/home/jorrit" = {
    allowOther = true;
    directories = [
      ".config/BraveSoftware/Brave-Browser" # TODO make this configurable
      ".config/Code" # TODO make this configurable
      ".config/git" # TODO make this configurable
      ".config/obsidian"
      ".config/spotify" # TODO make this configurable
      ".vscode" # TODO make this configurable

      # # Wallpaper # TODO move to git
      # ".local/share/backgrounds"
      # ".local/share/gnome-background-properties"

      # Burn my windows # TODO make this configurable
      ".config/burn-my-windows/profiles"

      # Fish history
      ".local/share/fish"

      # Color profile
      ".local/share/icc"

      # Keyrings
      ".local/share/keyrings"

      # User folders
      "Desktop"
      "Documents"
      "Downloads"
      "Git"
      "Music"
      "Pictures"
      "Public"
      "Templates"
      "Videos"
      ".ssh"
    ];
    files = [
      ".config/monitors.xml"
      ".screenrc"
    ];
  };
}
