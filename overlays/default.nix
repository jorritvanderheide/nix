{inputs, ...}: let
  agenixOverlay = import inputs.agenix.overlay;
in {
  overlays = [
    agenixOverlay
  ];
}
