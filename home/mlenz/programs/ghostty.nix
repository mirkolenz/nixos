{ pkgs, ... }:
{
  programs.ghostty-homebrew = {
    enable = pkgs.stdenv.isDarwin;
    settings = {
      font-family = "Berkeley Mono";
      # theme = "catppuccin-mocha";
      theme = "GitHub Dark";
    };
  };
}
