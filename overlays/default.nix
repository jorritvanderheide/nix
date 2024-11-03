{inputs, ...}: let
  myLib = import ./default.nix {inherit inputs;};

  # Helper function to scan directories and import overlays
  importOverlays = dir: let
    files = myLib.filesIn dir;
    overlays = map (f: import f {inherit inputs;}) files;
  in
    overlays;

  # Combine all overlays into one
  combinedOverlay = final: prev: myLib.lib.foldl' (acc: overlay: overlay acc) prev (importOverlays ../overlays);
in {
  overlays = [
    combinedOverlay
  ];
}
