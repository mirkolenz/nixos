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
          # keep-sorted start
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
          # keep-sorted end
        };
        programs.nixf-diagnose = {
          variableLookup = true;
          ignore = [
            # some code is commented out
            "sema-unused-def-let"
            # unknown builtin `getFlake`
            "sema-primop-unknown"
            # overriding a builtin name `fetchurl` is discouraged, rename it to avoid confusion
            "sema-primop-overridden"
          ];
        };
      };
      packages.treefmt-nix = config.treefmt.build.wrapper;
    };
}
