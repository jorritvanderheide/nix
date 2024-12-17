{inputs, ...}: {
  # Nix
  nix = {
    extraOptions = ''
      trusted-users = root jorrit
    '';
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command"];
      keep-outputs = true;
      warn-dirty = false;
    };
  };

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;
}
