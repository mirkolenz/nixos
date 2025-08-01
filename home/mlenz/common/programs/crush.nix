{ config, lib, ... }:
{
  programs.claude-code = lib.mkIf config.custom.profile.isWorkstation {
    enable = true;
  };
}
