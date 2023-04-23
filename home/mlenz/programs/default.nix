{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./micro.nix
    ./neovim.nix
    ./ssh.nix
  ];

  programs = {
    home-manager.enable = true;
    htop = {
      enable = true;
    };
    # texlive = {
    #   enable = true;
    # };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
    };
    bash = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    nix-index = {
      enable = true;
    };
  };
}
