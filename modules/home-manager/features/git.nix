{...}: {
  programs.git = {
    userName = "jorrit";
    userEmail = "35707261+jorritvanderheide@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = ["/etc/nixos"];
    };
  };
}