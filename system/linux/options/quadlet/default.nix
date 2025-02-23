{
  lib,
  lib',
  ...
}:
let
  inherit (lib) types mkOption;
in
{
  imports = lib'.flocken.getModules ./.;
  options.virtualisation.quadlet = {
    containers = mkOption {
      type = types.attrsOf (types.submodule ./_container.nix);
    };
  };
}
