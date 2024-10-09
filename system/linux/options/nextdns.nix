{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.nextdns-link;
in
{
  options.custom.nextdns-link = with lib; {
    enable = mkEnableOption "Link IP to NextDNS";
    name = mkOption {
      type = types.str;
      description = "Name of the service/timer";
      default = "nextdns-link";
    };
    url = mkOption {
      type = types.str;
      description = "NextDNS link URL";
      default = "$NEXTDNS_LINK_URL";
    };
    envFile = mkOption {
      type = with types; nullOr path;
      description = "Path to NextDNS environment file";
    };
    interval = mkOption {
      type = types.str;
      description = "Interval to run the service";
      default = "5m";
    };
  };
  systemd = lib.mkIf cfg.enable {
    timers.${cfg.name} = {
      wantedBy = [ "timers.target" ];
      description = "Link IP to NextDNS";
      timerConfig = {
        OnBootSec = cfg.interval;
        OnUnitActiveSec = cfg.interval;
        Unit = "${cfg.name}.service";
      };
    };
    services.${cfg.name} = {
      script = ''
        ${lib.getExe pkgs.wget} "${cfg.url}" -O -
      '';
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        EnvironmentFile = lib.mkIf (cfg.envFile != null) cfg.envFile;
      };
    };
  };
}
