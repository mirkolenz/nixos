{
  lib,
  lib',
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkOption;
  cfg = config.virtualisation.quadlet;
in
{
  imports = lib'.flocken.getModules ./.;
  options.virtualisation.quadlet = {
    # TODO: Make sure that all quadlet options are disabled if set to false
    enable = mkOption {
      default = true;
      type = with types; bool;
    };
    containers = mkOption {
      type = types.attrsOf (
        types.submodule (
          import ./_container.nix {
            quadletCfg = cfg;
            inherit (pkgs) writeShellApplication;
          }
        )
      );
    };
  };
}
