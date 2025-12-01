{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  time.timeZone = "Europe/Berlin";
}
