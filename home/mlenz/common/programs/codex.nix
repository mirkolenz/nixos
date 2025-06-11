{ config, ... }:
{
  programs.codex-rs = {
    enable = config.custom.profile.isWorkstation;
  };
}
