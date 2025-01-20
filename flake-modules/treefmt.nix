{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          prettier.enable = true;
          ruff-check.enable = true;
          ruff-format.enable = true;
          texfmt.enable = true;
        };
      };
      packages.treefmt-nix = config.treefmt.build.wrapper;
    };
}
