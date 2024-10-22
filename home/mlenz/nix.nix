{
  pkgs,
  lib,
  osConfig,
  os,
  channel,
  inputs,
  lib',
  ...
}:
{
  nix = lib.mkIf (osConfig == { }) {
    package = pkgs.nix;
    registry = lib'.self.mkRegistry { inherit inputs os channel; };
  };
}
