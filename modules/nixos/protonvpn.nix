#                  _                               
#  _ __  _ __ ___ | |_ ___  _ ____   ___ __  _ __  
# | '_ \| '__/ _ \| __/ _ \| '_ \ \ / / '_ \| '_ \ 
# | |_) | | | (_) | || (_) | | | \ V /| |_) | | | |
# | .__/|_|  \___/ \__\___/|_| |_|\_/ | .__/|_| |_|
# |_|                                 |_|          

{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.protonvpn;

in {
  options = {
    services.protonvpn = {
      enable = mkEnableOption "Enable ProtonVPN (using Wireguard).";

      autostart = mkOption {
        default = true;
        example = "true";
        type = types.bool;
        description = "Automatically set up ProtonVPN when NixOS boots.";
      };

      interface = {
        name = mkOption {
          default = "ProtonVPN";
          example = "NixOS";
          type = types.str;
          description = "The name of the Wireguard network interface to create. Go to https://account.protonmail.com/u/0/vpn/WireGuard to create a Linux Wireguard certificate and download it. You'll need it's content to set the options for this module.";
        };

        ip = mkOption {
          default = "10.2.0.2/32";
          example = "10.2.0.2/32";
          type = types.str;
          description = "The IP address of the interface. See your Wireguard certificate.";
        };

        port = mkOption {
          default = 51820;
          example = 51820;
          type = types.port;
          description = "The port number of the interface.";
        };

        privateKeyFile = mkOption {
          default = "/etc/wireguard/privatekey";
          example = "/etc/wireguard/privatekey";
          type = types.path;
          description = "The path to a file containing the private key for this interface/peer. Only root should have access to the file. See your Wireguard certificate.";
        };

        dns = {
          enable = mkOption {
            default = true;
            example = "true";
            type = types.bool;
            description = "Enable the DNS provided by ProtonVPN";
          };

          ip = mkOption {
            default = "10.2.0.1";
            example = "10.2.0.1";
            type = types.str;
            description = "The IP address of the DNS provided by the VPN. See your Wireguard certificate.";
          };
        };
      };

      endpoint = {
        publicKey = mkOption {
          default = "1s5mwMp3fZKNucEO3GeHRSUrhGLu/BYeC0UdusyxSWU=";
          example = "1s5mwMp3fZKNucEO3GeHRSUrhGLu/BYeC0UdusyxSWU=";
          type = types.str;
          description = "The public key of the VPN endpoint. See your Wireguard certificate.";
        };

        ip = mkOption {
          default = "138.199.7.159";
          example = "138.199.7.159";
          type = types.str;
          description = "The IP address of the VPN endpoint. See your Wireguard certificate.";
        };

        port = mkOption {
          default = 51820;
          example = 51820;
          type = types.port;
          description = "The port number of the VPN peer endpoint. See your Wireguard certificate.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces."${cfg.interface.name}" = {
      autostart = cfg.autostart;
      dns = if cfg.interface.dns.enable then [ cfg.interface.dns.ip ] else [ ];
      privateKeyFile = cfg.interface.privateKeyFile;
      address = [ cfg.interface.ip ];
      listenPort = cfg.interface.port;

      peers = [
        {
          publicKey = cfg.endpoint.publicKey;
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "${cfg.endpoint.ip}:${builtins.toString cfg.endpoint.port}";
        }
      ];
    };
  };
}
