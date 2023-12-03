{
  config,
  pkgs,
  lib,
  user,
  ...
}: let
  cfg = config.custom.docker;
in {
  options.custom.docker = {
    enable = lib.mkEnableOption "Docker";
    usernsRemap = lib.mkEnableOption "userns-remap";
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
        userns-remap = lib.mkIf cfg.usernsRemap user.login;
      };
    };
  };
}
