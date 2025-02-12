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
      lib.mapAttrs (system: attrs: attrs.checked-packages) self.legacyPackages
    );
  };
}
