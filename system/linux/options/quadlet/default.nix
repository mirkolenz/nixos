{
  lib,
  lib',
  config,
  ...
}:
let
  inherit (lib) types mkOption;
  cfg = config.virtualisation.quadlet;
in
{
  imports = lib'.flocken.getModules ./.;
  options.virtualisation.quadlet = {
    containers = mkOption {
      type = types.attrsOf (
        types.submodule (
          import ./_container.nix {
            quadletCfg = cfg;
          }
        )
      );
    };
  };
}
