{ lib', lib, ... }:
{
  imports = lib'.flocken.getModules ./.;
  options.custom.features = {
    withOptionals = lib.mkEnableOption "optional plugins" // {
      default = true;
    };
  };
}
