{ lib, config, ... }:
let
  cfg = config.custom.caches;
in
{
  options.custom.caches =
    with lib;
    mkOption {
      description = "Binary caches to use for fetching packages.";
      type = types.listOf (
        types.submodule {
          options = {
            url = mkOption { type = types.str; };
            key = mkOption { type = types.str; };
          };
        }
      );
      default = { };
    };
  config = lib.mkIf (cfg != { }) {
    nix.settings = {
      substituters = map (c: c.url) cfg;
      trusted-public-keys = map (c: c.key) cfg;
    };
  };
}
