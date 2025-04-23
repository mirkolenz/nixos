{ config, lib, ... }:
let
  cfg = config.custom.docker;
in
{
  options.custom.docker = {
    enable = lib.mkEnableOption "Docker";
    userns = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
    };
    enableIcc = lib.mkEnableOption "Enable inter-container communication";
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
