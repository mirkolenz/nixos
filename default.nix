{ ... }:
let
  flake = builtins.getFlake ("git+file://" + toString ./.);
  overlay = import ./overlays {
    inherit (flake) inputs;
    self = flake;
    lib' = flake.lib;
  };
in
import flake.inputs.nixpkgs {
  system = builtins.currentSystem;
  overlays = [ overlay ];
  config = flake.nixpkgsConfig;
}
