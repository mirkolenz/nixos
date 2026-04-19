{ lib, config, ... }:
lib.mkIf config.custom.features.withAlwaysOn {
  system.autoUpgrade.enable = true;

  systemd.sleep.settings.Sleep = lib.mkDefault {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
  };
}
