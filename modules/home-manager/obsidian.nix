{ config, pkgs, ... }:

{
  # Install the Obsidian app
  home-manager.users."${config.users.users.0.name}".packages = [
    pkgs.obsidian
  ];

  # Clone vault from git using personal access token
 
  # Set


}


