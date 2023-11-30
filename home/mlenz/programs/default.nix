{...}: {
  imports = [
    ./bottom.nix
    ./git.nix
    ./hyfetch.nix
    ./micro.nix
    ./nixvim.nix
    ./pandoc.nix
    ./shells.nix
    ./ssh.nix
    ./starship.nix
    ./texlive.nix
    ./tmux.nix
  ];

  programs = {
    home-manager.enable = true;
    htop.enable = true;
    btop.enable = true;
    nix-index.enable = true;
    bat.enable = true;
    ripgrep.enable = true;
    carapace.enable = true;
    thefuck.enable = true;
  };
}
