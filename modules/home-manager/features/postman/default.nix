{pkgs, ...}: {
  home.packages = with pkgs; [
    postman
  ];

  myHomeManager.impermanence.directories = [
    ".config/Postman"
  ];
}
