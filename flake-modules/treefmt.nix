{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          buf.enable = true;
          gofmt.enable = true;
          google-java-format.enable = true;
          nixfmt.enable = true;
          prettier.enable = true;
          ruff-check.enable = true;
          ruff-format.enable = true;
          rustfmt.enable = true;
          texfmt.enable = true;
          typstyle.enable = true;
          yamlfmt.enable = true;
        };
      };
      packages.treefmt-nix = config.treefmt.build.wrapper;
    };
}
