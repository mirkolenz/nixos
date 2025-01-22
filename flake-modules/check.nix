{
  lib,
  self,
  inputs,
  ...
}:
let
  evalPackages =
    { }
    // (lib.mapAttrs' (name: module: {
      name = "darwin-config-${name}";
      value = module.config.system.build.toplevel;
    }) self.darwinConfigurations)
    // (lib.mapAttrs' (name: module: {
      name = "home-config-${name}";
      value = module.activationPackage;
    }) self.homeConfigurations);

  noBuildPackages = (lib.attrNames evalPackages) ++ [
    "default"
    "nixvim"
  ];
  buildSystems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  shouldBuild = name: _: !lib.elem name noBuildPackages;
  buildPackagesPerSystem = lib.getAttrs buildSystems self.packages;
  getBuildPackage = system: packages: lib.filterAttrs shouldBuild packages;
in
{
  perSystem =
    { ... }:
    {
      packages = evalPackages;
    };
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.mapAttrs getBuildPackage buildPackagesPerSystem;
  };
}
