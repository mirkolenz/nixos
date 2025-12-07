# https://github.com/NixOS/nixpkgs/blob/master/ci/default.nix
{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          actionlint.enable = true;
          buf.enable = true;
          gofmt.enable = true;
          google-java-format.enable = true;
          keep-sorted.enable = true;
          nixf-diagnose.enable = true;
          nixfmt.enable = true;
          prettier.enable = true;
          ruff-check.enable = true;
          ruff-format.enable = true;
          rustfmt.enable = true;
          texfmt.enable = true;
          typstyle.enable = true;
          yamlfmt.enable = true;
        };
        settings.formatter.nixf-diagnose = {
          # Ensure nixfmt cleans up after nixf-diagnose.
          priority = -1;
          options = [
            "--auto-fix"
            "--ignore=sema-unused-def-let"
          ];
        };
      };
      packages.treefmt-nix = config.treefmt.build.wrapper;
    };
}
