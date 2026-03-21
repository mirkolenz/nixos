{ ... }:
{
  programs.mosh.enable = false;
  services.eternal-terminal.enable = false;
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
