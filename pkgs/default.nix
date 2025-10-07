args: final: prev:
let
  inherit (prev) lib;

  current = lib.packagesFromDirectoryRecursive {
    callPackage = lib.callPackageWith (
      final
      // {
        inherit (args) inputs;
        inherit prev;
      }
    );
    directory = ./by-name;
  };

  drvs = lib.filterAttrs (name: value: lib.isDerivation value) current;

  scopes = lib.filterAttrs (
    name: value:
    !lib.isDerivation value
    && lib.isAttrs value
    && lib.all (n: lib.isDerivation n) (lib.attrValues value)
  ) current;

  scopedDrvs = lib.concatMapAttrs (
    scopeName: scopeValue:
    lib.mapAttrs' (drvName: drvValue: {
      name = "${scopeName}-${drvName}";
      value = drvValue;
    }) scopeValue
  ) scopes;

  # scopedPkgs = lib.mapAttrs (name: value: prev.${name} // value) scopes;

in
lib.mergeAttrsList [
  (args.inputs.nix-darwin.overlays.default final prev)
  (import ./inputs.nix args final prev)
  (import ./overrides.nix final prev)
  current
  {
    drvs = drvs // scopedDrvs;
    vimPlugins = prev.vimPlugins // current.vimPlugins;
  }
]
