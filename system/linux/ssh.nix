{ config, user, ... }:
{
  security.pam = {
    rssh = {
      inherit (config.services.openssh) enable;
      settings.auth_key_file = "/etc/ssh/authorized_keys.d/${user.login}";
    };
    services.sudo.rssh = config.services.openssh.enable && config.security.pam.rssh.enable;
  };
  services.openssh = {
    authorizedKeysInHomedir = false;
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
