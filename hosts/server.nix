{ pkgs,... }:
{
  imports = [ ./ssh.nix ];
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    flake = "mirkolenz/nixos";
    # flags = [ "--recreate-lock-file" ];
  };
  users.users.mlenz = {
    subUidRanges = [
      { count = 1; startUid = 1000; }
      { count = 65536; startUid = 100001; }
    ];
    subGidRanges = [
      { count = 1; startGid = 1000; }
      { count = 65536; startGid = 100001; }
    ];
  };
  virtualisation.docker = {
    # logDriver = "json-file";
    autoPrune = {
      enable = true;
      dates = "daily";
    };
    daemon.settings = {
      "icc" = false;
      "userns-remap" = "mlenz";
    };
  };
}
