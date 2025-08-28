{ config, ... }:
{
  imports = [
    ./codex.nix
    ./claude.nix
  ];
  programs.opencode.enable = config.custom.profile.isWorkstation;
  programs.ssh.enableDefaultConfig = false;
}
