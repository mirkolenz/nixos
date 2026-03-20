{ ... }:
{
  security = {
    pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
      watchIdAuth = true;
    };
    sudo.extraConfig = ''
      Defaults env_keep -= "HOME"
      Defaults pwfeedback
    '';
  };
}
