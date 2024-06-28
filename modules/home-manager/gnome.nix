#                                   
#   __ _ _ __   ___  _ __ ___   ___ 
#  / _` | '_ \ / _ \| '_ ` _ \ / _ \
# | (_| | | | | (_) | | | | | |  __/
#  \__, |_| |_|\___/|_| |_| |_|\___|
#  |___/                            

{ lib, config, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///persist/home/jorrit/Pictures/Backgrounds/background-light.png";
      picture-uri-dark = "file:///persist/home/jorrit/Pictures/Backgrounds/background-dark.png";
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = false;
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/desktop/lockdown" = {
      disable-user-switching = true;
    };

    "org/gnome/desktop/screensaver" = {
      # lock-enabled = false;
    };

    "org/gnome/desktop/session" = {
      idle-delay = 60;
    };

    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
      workspaces-only-on-primary = true;
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 4700;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      # power-button-action = "hibernate";
      sleep-inactive-ac-timeout = 600;
      sleep-inactive-battery-timeout = 600;
    };

    "org/gnome/shell" = {
      welcome-dialog-last-shown-version = "46.2";
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "burn-my-windows@schneegans.github.com"
        "caffeine@patapon.info"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "impatience@gfxmonk.net"
        "nightthemeswitcher@romainvigier.fr"
        "no-overview@fthx"
      ];
      favorite-apps = [
        "brave-browser.desktop"
        "code.desktop"
        "obsidian.desktop"
        "spotify.desktop"
      ];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/blur-my-shell/panel" = {
      override-background = true;
      override-background-dynamically = true;
    };

    "org/gnome/shell/extensions/burn-my-windows" = {
      active-profile = "/persist/home/jorrit/.config/burn-my-windows/profiles/1718655678027134.conf";
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      display-mode = 3;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      hot-keys = false;
      show-icons-emblems = false;
      show-mounts = false;
      show-show-apps-button = false;
      show-trash = false;
    };
  };

  # Enable the triple buffering patch for Mutter
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "triple-buffering-v4-46";
            hash = "sha256-fkPjB/5DPBX06t7yj0Rb3UEuu5b9mu3aS+jhH18+lpI=";
          };
        });
      });
    })
  ];
}
