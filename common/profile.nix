args@{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.profile;
  osConfig = args.osConfig or { };
in
{
  options.custom.profile = {
    isDesktop = lib.mkEnableOption "desktop";
    isServer = lib.mkEnableOption "server";
    isWorkstation = lib.mkEnableOption "workstation" // {
      default = cfg.isDesktop;
    };
    isHeadless = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
    };
  };
  config.custom.profile = {
    isHeadless = !cfg.isDesktop || cfg.isServer;
  }
  // (osConfig.custom.profile or { });
}
