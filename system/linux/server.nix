{ lib, config, ... }:
lib.mkMerge [
  (lib.mkIf
    (lib.elem config.custom.profile [
      "headless"
      "server"
    ])
    {
      services.openssh.enable = lib.mkDefault true;
      environment.variables.BROWSER = "echo";
    }
  )
  (lib.mkIf (config.custom.profile == "server") {
    services.openssh.enable = true;

    system.autoUpgrade = {
      enable = true;
      flake = "github:mirkolenz/nixos";
      flags = lib.optional config.custom.impure_rebuild "--impure";
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
