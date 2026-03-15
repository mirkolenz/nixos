args@{ lib, ... }:
{
  options.custom.features = {
    withAlwaysOn = lib.mkEnableOption "always on";
    withOptionals = lib.mkEnableOption "all packages";
    withDisplay = lib.mkEnableOption "display";
  };
  config.custom.features = args.osConfig.custom.features or { };
}
