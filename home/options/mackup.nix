{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.mackup;
  iniFormat = pkgs.formats.ini { };
  mkList = values: lib.genAttrs values (_: "");
in
{
  options.custom.mackup = {
    enable = lib.mkEnableOption "Mackup";
    package = lib.mkPackageOption pkgs "Mackup" { default = [ "mackup" ]; };
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      description = "Settings for Mackup.";
      default = { };
      example = {
        storage.engine = "icloud";
      };
    };
    builtinApps = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Built-in applications to sync.";
      default = [ ];
    };
    customApps = lib.mkOption {
      type = with lib.types; attrsOf anything;
      description = "Custom applications to sync.";
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    home.file =
      {
        ".mackup.cfg".source = iniFormat.generate "mackup-config" (
          cfg.settings
          // {
            applications_to_sync = mkList (cfg.builtinApps ++ (builtins.attrNames cfg.customApps));
          }
        );
      }
      // (lib.mapAttrs' (name: value: {
        name = ".mackup/${name}.cfg";
        value = {
          source = iniFormat.generate "mackup-config-${name}" value;
        };
      }) cfg.customApps);
    home.packages = lib.singleton cfg.package;
  };
}
