{ config, ... }:
{
  programs.opencode.enable = config.custom.profile.isWorkstation;
}
