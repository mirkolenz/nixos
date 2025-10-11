args@{ lib', ... }:
final: prev:
let
  inherit (prev) lib;

  current = lib.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./derivations;
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

  overrides = lib'.importOverlays ./overrides final prev;

in
lib.mergeAttrsList [
  (args.inputs.nix-darwin.overlays.default final prev)
  (import ./inputs.nix args final prev)
  (import ./patches.nix final prev)
  pkgs
  overrides
  {
    drvs = drvs // flatScopeDrvs // overrides;
  }
]
