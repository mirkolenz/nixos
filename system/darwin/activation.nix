{ ... }:
{
  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/system/activation-scripts.nix
  system.activationScripts = {
    preActivation.text = /* bash */ '''';
    extraActivation.text = /* bash */ '''';
    postActivation.text = /* bash */ ''
      /usr/local/bin/determinate-nixd upgrade
    '';
  };
}
