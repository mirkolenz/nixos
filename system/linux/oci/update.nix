{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.oci;
  updateCfg = cfg.update;
in
{
  options.custom.oci.update = with lib; {
    enable = mkEnableOption "Automatic updates of container images";
    startAt = mkOption {
      type = types.str;
      description = "Systemd timer start time";
      # default = "*-*-* 02:00:00";
    };
  };
  config = lib.mkIf (cfg.enable && updateCfg.enable) {
    systemd.services.oci-update = {
      inherit (updateCfg) startAt;
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${lib.getExe' pkgs.podman "podman"} auto-update
      '';
    };
  };
}
