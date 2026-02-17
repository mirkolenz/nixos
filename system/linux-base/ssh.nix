{ config, lib, ... }:
{
  security.pam = lib.mkIf config.services.openssh.enable {
    rssh.enable = true;
    services.sudo.rssh = true;
  };
  services.openssh = {
    authorizedKeysInHomedir = false;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
