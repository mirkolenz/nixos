{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  programs = {
    btop.enable = true;
    carapace.enable = false;
    fastfetch.enable = true;
    gradle.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    jq.enable = true;
    jqp.enable = true;
    nix-index.enable = true;
    pandoc.enable = true;
    ripgrep.enable = true;
    thefuck.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
  };
}
