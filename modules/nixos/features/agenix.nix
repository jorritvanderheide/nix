{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS.agenix = {
    secrets = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Attribute set of Agenix secrets";
    };
  };

  config = {
    # Agenix package
    environment.systemPackages = [
      inputs.agenix.packages."x86_64-linux".default
    ];

    # Secrets
    age.secrets = {} // cfg.agenix.secrets;

    # Impermanence compatibility for user login
    fileSystems."/etc/ssh".neededForBoot = true;
  };
}
