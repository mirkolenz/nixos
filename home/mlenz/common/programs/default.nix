{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    btop.enable = true;
    nix-index.enable = true;
    ripgrep.enable = true;
    carapace.enable = false;
    thefuck.enable = true;
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ruff.enable
    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gradle.enable
  };
}
