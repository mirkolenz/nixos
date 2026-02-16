{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
}
