{ lib', lib, ... }:
{
  imports = lib'.flocken.getModules ./.;
  options.custom = {
    enableOptionalPlugins = lib.mkEnableOption "optional plugins" // {
      default = true;
    };
  };
}
