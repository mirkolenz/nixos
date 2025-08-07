{ config, ... }:
{
  programs.opencode.enable = config.custom.profile.isWorkstation;
  programs.codex.enable = config.custom.profile.isWorkstation;
}
