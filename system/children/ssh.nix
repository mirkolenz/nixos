{ ... }:
{
  security.pam = {
    rssh.enable = true;
    services.sudo.rssh = true;
  };
  services.openssh = {
    enable = true;
    authorizedKeysInHomedir = false;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };
}
