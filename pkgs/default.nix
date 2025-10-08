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

  scopes = [ "vimPlugins" ];

  drvs = lib.filterAttrs (name: value: lib.isDerivation value) current;

  scopeDrvs = lib.getAttrs scopes current;

  flatScopeDrvs = lib.concatMapAttrs (
    scopeName: scopeValue:
    lib.mapAttrs' (drvName: drvValue: {
      name = "${scopeName}-${drvName}";
      value = drvValue;
    }) scopeValue
  ) scopeDrvs;

  pkgs = current // (lib.mapAttrs (name: value: prev.${name} // value) scopeDrvs);

in
lib.mergeAttrsList [
  (args.inputs.nix-darwin.overlays.default final prev)
  (import ./inputs.nix args final prev)
  (import ./overrides.nix final prev)
  pkgs
  {
    drvs = drvs // flatScopeDrvs;
  }
]
