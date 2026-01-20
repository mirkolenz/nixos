args@{ lib', ... }:
final: prev:
let
  inherit (prev) lib;

  scopes = [ "vimPlugins" ];
  overridesUpdate = [ ];
  inputsExport = [ "opencode" ];

  current = lib.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./derivations;
  };

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
  inputs = import ./inputs.nix args final prev;
  hotfixes = import ./hotfixes.nix final prev;

in
lib.mergeAttrsList [
  (args.inputs.nix-darwin.overlays.default final prev)
  inputs
  hotfixes
  pkgs
  overrides
  {
    drvsExport = drvs // flatScopeDrvs // overrides // (lib.getAttrs inputsExport inputs);
    drvsUpdate = drvs // flatScopeDrvs // (lib.getAttrs overridesUpdate overrides);
  }
]
