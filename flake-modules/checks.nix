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
in
{
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems (
      lib.mapAttrs (
        system: pkgs:
        pkgs.exported-packages
        // {
          inherit (pkgs) nixvim-unstable;
        }
      ) self.legacyPackages
    );
  };
}
