{
  flake-parts-lib,
  lib,
  ...
}:
flake-parts-lib.mkTransposedPerSystemModule {
  name = "hydraJobs";
  option = lib.mkOption {
    type = with lib.types; lazyAttrsOf raw;
    default = { };
  };
  file = ./hydra.nix;
}
