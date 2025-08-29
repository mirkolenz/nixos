{ ... }:
{
  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix
  system.activationScripts = {
    extraActivation.text = "";
    preActivation.text = "";
    postActivation.text = ''
      /usr/local/bin/determinate-nixd upgrade
    '';
  };
}
