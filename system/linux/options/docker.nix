{ config, lib, ... }:
let
  cfg = config.custom.docker;
in
{
  options.custom.docker = with lib; {
    enable = mkEnableOption "Docker";
    userns = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    enableIcc = mkEnableOption "Enable inter-container communication";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
      daemon.settings = {
        icc = cfg.enableIcc;
        userns-remap = lib.mkIf (cfg.userns != null) cfg.userns;
      };
    };
  };
}
