{ pkgs, ... }:
{
  programs.ghostty-homebrew = {
    enable = pkgs.stdenv.isDarwin;
    settings = {
      font-family = "Berkeley Mono";
      font-size = 13;
      font-thicken = true;
      theme = "GitHub Dark";
      shell-integration = "none";
    };
  };
}
