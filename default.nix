# https://github.com/Mic92/nix-update/blob/main/nix_update/eval.py#L142
{
  system ? builtins.currentSystem,
  ...
}:
let
  flake = builtins.getFlake ("git+file://" + toString ./.);
in
import flake.inputs.nixpkgs {
  inherit system;
  overlays = [ flake.overlays.default ];
  config = flake.nixpkgsConfig;
}
