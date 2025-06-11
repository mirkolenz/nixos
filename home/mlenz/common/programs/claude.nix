{ config, ... }:
{
  programs.claude-code = {
    enable = config.custom.profile.isWorkstation;
  };
}
