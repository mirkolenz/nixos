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
  filterPackages =
    name: value:
    !lib.elem name [
      "bibtexbrowser2cff"
    ]
    && !lib.hasSuffix "-docker" name;
in
{
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems (
      lib.mapAttrs (
        system: pkgs: (lib.filterAttrs filterPackages pkgs.exported-packages) // (extraPackages pkgs)
      ) self.legacyPackages
    );
  };
}
