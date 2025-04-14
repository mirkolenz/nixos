{
  lib,
  self,
  inputs,
  ...
}:
let
  systems = [
    "x86_64-linux"
  ];
  extraPackages = pkgs: {
    inherit (pkgs) nixvim-unstable;
  };
in
{
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems (
      lib.mapAttrs (system: pkgs: pkgs.exported-packages // (extraPackages pkgs)) self.legacyPackages
    );
  };
}
