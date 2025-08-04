{ config, ... }:
{
  opencode.enable = config.custom.profile.isWorkstation;
}
