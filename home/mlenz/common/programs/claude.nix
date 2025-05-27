{ config, ... }:
{
  programs.claude = {
    enable = config.custom.profile.isDesktop;
    settings = { };
  };
}
