{ pkgs, ... }:
{
  programs.ghostty-custom = {
    enable = pkgs.stdenv.isDarwin;
    settings = {
      cursor-click-to-move = true;
      font-family = "TX-02";
      font-size = 13;
      font-thicken = true;
      shell-integration = "none";
      shell-integration-features = "no-cursor,sudo,title";
      theme = "Builtin Dark";
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
