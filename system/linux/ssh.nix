{ config, ... }:
{
  security.pam = {
    rssh.enable = config.services.openssh.enable;
    services.sudo.rssh = config.services.openssh.enable && config.security.pam.rssh.enable;
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
