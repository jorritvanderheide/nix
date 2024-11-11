{pkgs, ...}: {
  nixpkgs.config = {
    permittedInsecurePackages = [
      "segger-jlink-qt4-796s"
    ];
    segger-jlink.acceptLicense = true;
  };

  home.packages = with pkgs; [
    nrf-command-line-tools
    nrfconnect
    nrfutil
  ];
}
