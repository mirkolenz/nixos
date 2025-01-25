{
  lib,
  self,
  inputs,
  ...
}:
let
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];
  checks = lib.mapAttrs (system: packages: packages.github-checks) self.legacyPackages;
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
