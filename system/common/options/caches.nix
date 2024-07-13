{ lib, config, ... }:
let
  cfg = config.custom.nix-binary-caches;
in
{
  options.custom.nix-binary-caches =
    with lib;
    mkOption {
      description = "Binary caches to use for fetching packages.";
      type = with types; attrsOf str;
      default = { };
    };
  config = lib.mkIf (cfg != { }) {
    nix.settings = {
      substituters = builtins.attrNames cfg;
      trusted-substituters = builtins.attrNames cfg;
      trusted-public-keys = builtins.attrValues cfg;
    };
  };
}
