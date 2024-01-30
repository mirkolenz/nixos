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
    settings = {
      substituters = [ "https://mirkolenz.cachix.org" ];
      trusted-public-keys = [ "mirkolenz.cachix.org-1:R0dgCJ93t33K/gncNbKgUdJzwgsYVXeExRsZNz5jpho=" ];
    };
  };
}
