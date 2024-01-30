args@{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  nix = lib.mkIf (osConfig == { }) {
    package = pkgs.nix;
    registry = import ../../registry.nix args;
  };
}
