{inputs, ...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.myHomeManager.theming = {
  };

  config = {
    stylix = {
      # enable = true;
      homeManagerIntegration.followSystem = true;
    };
  };
}
