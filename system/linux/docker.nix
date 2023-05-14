{ config, pkgs, lib, ... }:
let
  cfg = config.custom.docker;
in
{
  options.custom.docker = {
    enable = lib.mkEnableOption "Docker";
    userns-remap = lib.mkEnableOption "userns-remap";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # logDriver = "json-file";
      autoPrune = {
        enable = true;
        dates = "daily";
      };
      daemon.settings = {
        icc = false;
        userns-remap = lib.mkIf cfg.userns-remap "mlenz";
      };
    };
    users.users.mlenz = lib.mkIf cfg.userns-remap {
      subUidRanges = [
        { count = 1; startUid = 1000; }
        { count = 65536; startUid = 100001; }
      ];
      subGidRanges = [
        { count = 1; startGid = 1000; }
        { count = 65536; startGid = 100001; }
      ];
    };
  };
}
