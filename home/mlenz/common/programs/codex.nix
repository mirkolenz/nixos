{ config, ... }:
{
  programs.codex = {
    enable = config.custom.profile.isWorkstation;
  };
}
