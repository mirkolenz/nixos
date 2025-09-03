{
  flake-parts-lib,
  lib,
  ...
}:
{
  imports = lib.singleton (
    flake-parts-lib.mkTransposedPerSystemModule {
      name = "githubActionsChecks";
      option = lib.mkOption {
        type = with lib.types; lazyAttrsOf package;
        default = { };
      };
      file = ./checks.nix;
    }
  );
  perSystem =
    { pkgs, config, ... }:
    {
      githubActionsChecks.default = pkgs.releaseTools.aggregate {
        name = "github-actions-checks";
        constituents = lib.attrValues (
          lib.filterAttrs (name: pkg: pkg.meta.githubActionsCheck or false) config.packages
        );
      };
    };
}
