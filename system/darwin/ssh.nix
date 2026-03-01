{ ... }:
{
  services.openssh = {
    enable = true;
    extraConfig = ''
      KbdInteractiveAuthentication no
      PasswordAuthentication no
      PermitRootLogin no
      X11Forwarding no
    '';
  };
}
