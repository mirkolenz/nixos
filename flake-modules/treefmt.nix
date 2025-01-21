{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { ... }:
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
    };
}
