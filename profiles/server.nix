{ ... }:
{
  imports = [ ./headless.nix ];

  services.openssh.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = "github:mirkolenz/nixos";
    flags = [ "--impure" ];
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
}
