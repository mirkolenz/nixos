{
  lib,
  self,
  ...
}:
let
  evalChecks =
    { }
    // (lib.mapAttrs' (name: module: {
      name = "nixos-config-${name}";
      value = module.config.system.build.toplevel;
    }) self.nixosConfigurations)
    // (lib.mapAttrs' (name: module: {
      name = "darwin-config-${name}";
      value = module.config.system.build.toplevel;
    }) self.darwinConfigurations)
    // (lib.mapAttrs' (name: module: {
      name = "home-config-${name}";
      value = module.activationPackage;
    }) self.homeConfigurations);

  onlyEvalPackage = name: _: !lib.elem name (lib.attrNames evalChecks);
in
{
  perSystem =
    { config, ... }:
    {
      checks = lib.filterAttrs onlyEvalPackage config.packages;
      packages = evalChecks;
    };
}
