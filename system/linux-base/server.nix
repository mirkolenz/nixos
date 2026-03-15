{ lib, config, ... }:
lib.mkIf config.custom.features.withAlwaysOn {
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

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
  };
}
