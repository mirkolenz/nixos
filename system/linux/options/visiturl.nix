{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.visiturl;
in
{
  options.custom.visiturl =
    with lib;
    mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              enable = mkEnableOption "periodically visit a URL";
              name = mkOption {
                type = types.str;
                default = name;
              };
              description = mkOption {
                type = types.str;
                default = "";
              };
              url = mkOption {
                type = types.str;
                example = "$URL";
              };
              interval = mkOption {
                type = types.str;
              };
              envFile = mkOption {
                type = with types; nullOr path;
                default = null;
              };
            };
          }
        )
      );
    };
  config = {
    systemd.timers = lib.mapAttrs' (_: entry: {
      inherit (entry) name;
      value = lib.mkIf entry.enable {
        wantedBy = [ "timers.target" ];
        description = entry.description;
        timerConfig = {
          OnBootSec = entry.interval;
          OnUnitActiveSec = entry.interval;
          Unit = "${entry.name}.service";
        };
      };
    }) cfg;
    systemd.services = lib.mapAttrs' (_: entry: {
      inherit (entry) name;
      value = lib.mkIf entry.enable {
        script = ''
          ${lib.getExe pkgs.wget} "${entry.url}" -O -
        '';
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          EnvironmentFile = lib.mkIf (entry.envFile != null) entry.envFile;
        };
      };
    }) cfg;
  };
}
