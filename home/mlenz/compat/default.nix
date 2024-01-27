{ lib, channel, ... }:
{
  imports = lib.singleton ./${channel}.nix;
}
