{
  config,
  lib,
  ...
}: let
  cfg = config.custom.podman;
in {
  options.custom.podman = {
    enable = lib.mkEnableOption "Podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      # logDriver = "json-file";
      autoPrune = {
        enable = true;
        dates = "daily";
      };
    };
    users.users.containers = {
      isSystemUser = true;
      group = "containers";
      subUidRanges = [
        {
          startUid = 2147483647;
          count = 2147483648;
        }
      ];
      subGidRanges = [
        {
          startGid = 2147483647;
          count = 2147483648;
        }
      ];
    };
    users.groups.containers = {};
  };
}
