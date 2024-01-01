{lib, ...}: {
  imports = lib.flocken.getModules ./.;

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    btop.enable = true;
    nix-index.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
    carapace.enable = false;
    thefuck.enable = true;
  };
}
