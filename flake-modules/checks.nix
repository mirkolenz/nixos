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
  checks = lib.mapAttrs (system: attrs: attrs.exported-packages) self.legacyPackages;
in
{
  perSystem =
    { ... }:
    {
      packages =
        { }
        // (lib.mapAttrs' (name: module: {
          name = "darwin-config-${name}";
          value = module.config.system.build.toplevel;
        }) self.darwinConfigurations)
        // (lib.mapAttrs' (name: module: {
          name = "home-config-${name}";
          value = module.activationPackage;
        }) self.homeConfigurations);
    };
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems checks;
  };
}
