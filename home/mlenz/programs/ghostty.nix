{ pkgs, ... }:
{
  programs.ghostty-homebrew = {
    enable = pkgs.stdenv.isDarwin;
    settings = {
      font-family = "TX-02";
      font-size = 13;
      font-thicken = true;
      shell-integration = "none";
      theme = "GitHub Dark";
      window-height = 30;
      window-padding-x = 8;
      window-padding-y = 8;
      window-width = 120;
    };
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };
}
