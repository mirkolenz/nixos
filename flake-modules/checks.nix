{
  lib,
  self,
  inputs,
  ...
}:
{
  perSystem =
    { config, pkgs, ... }:
    {
      packages.github-actions-check = pkgs.releaseTools.aggregate {
        name = "github-actions-check";
        constituents = lib.attrValues (
          lib.filterAttrs (name: pkg: pkg.meta.githubActionsCheck or false) config.packages
        );
      };
    };
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks =
      lib.getAttrs
        [
          "x86_64-linux"
          "aarch64-darwin"
        ]
        (
          lib.mapAttrs (system: pkgs: {
            default = pkgs.github-actions-check;
          }) self.packages
        );
    # https://docs.github.com/en/actions/how-tos/write-workflows/choose-where-workflows-run/choose-the-runner-for-a-job#standard-github-hosted-runners-for-public-repositories
    platforms = {
      "aarch64-darwin" = "macos-15";
      "aarch64-linux" = "ubuntu-24.04-arm";
      "x86_64-linux" = "ubuntu-24.04";
    };
  };
}
