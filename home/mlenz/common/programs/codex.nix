{ config, ... }:
{
  programs.codex = {
    enable = config.custom.profile.isDesktop;
    settings = {
      model = "o3";
    };
  };
}
