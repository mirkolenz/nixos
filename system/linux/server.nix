{ lib, config, ... }:
lib.mkMerge [
  (lib.mkIf config.custom.profile.isHeadless {
    services.openssh.enable = lib.mkDefault true;
    environment.variables.BROWSER = "echo";
  })
  (lib.mkIf config.custom.profile.isServer {
    system.autoUpgrade = {
      enable = true;
      flake = "github:mirkolenz/nixos";
      flags = lib.optional config.custom.impureRebuild "--impure";
      dates = "04:00";
      allowReboot = true;
      rebootWindow = {
        lower = "03:30";
        upper = "05:00";
      };
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  })
]
