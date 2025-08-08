{ config, ... }:
{
  imports = [
    ./codex.nix
  ];
  programs.opencode.enable = config.custom.profile.isWorkstation;
}
