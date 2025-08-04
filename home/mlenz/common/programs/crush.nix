{ config, lib, ... }:
{
  programs.crush = lib.mkIf config.custom.profile.isWorkstation {
    enable = true;
  };
}
