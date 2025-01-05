{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.quadlet;
  updateCfg = cfg.update;
in
{
  options.virtualisation.quadlet.update = with lib; {
    enable = mkEnableOption "Automatic updates of container images";
    startAt = mkOption {
      type = types.str;
      description = "Systemd timer start time";
      # default = "*-*-* 02:00:00";
    };
  };
  config = lib.mkIf (cfg.enable && updateCfg.enable) {
    systemd.services.quadlet-update = {
      inherit (updateCfg) startAt;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${lib.getExe pkgs.podman} auto-update
      '';
    };
  };
}
