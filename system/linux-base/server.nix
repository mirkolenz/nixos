{ lib, config, ... }:
lib.mkMerge [
  (lib.mkIf config.custom.profile.isHeadless {
    environment.variables.BROWSER = "echo";
  })
  (lib.mkIf config.custom.profile.isServer {
    system.autoUpgrade = {
      enable = true;
      flake = "github:mirkolenz/nixos";
      flags = lib.optional config.custom.impureRebuild "--impure";
      dates = "04:00";
      allowReboot = true;
      runGarbageCollection = true;
      rebootWindow = {
        lower = "03:30";
        upper = "05:00";
      };
    };

    systemd.targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
      suspend-then-hibernate.enable = false;
    };
  })
]
