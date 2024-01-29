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
      substituters = [ "https://mirkolenz-nixos.cachix.org" ];
      trusted-public-keys = [
        "mirkolenz-nixos.cachix.org-1:9WzIsoj8hYzpik6FxfmterPFEX7v1v2T30J6u08/wKE="
      ];
    };
  };
}
