{pkgs,...}:
{
  imports = [ ./hardware.nix ../server.nix ];
  networking.hostName = "homeserver";
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "mirkolenz/nixos";
    # flags = [ "--recreate-lock-file" ];
  };
  # logDriver = "json-file";
  autoPrune = {
    enable = true;
    dates = "daily";
  };
  daemon.settings = {
    "icc" = false;
    "userns-remap" = "mlenz";
  };
}
