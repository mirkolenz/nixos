args: final: prev:
let
  inherit (prev) lib;

  fromDirectory =
    directory:
    lib.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (final // { inherit (args) inputs; });
      inherit directory;
    };

  functions = fromDirectory ./functions;
  packages = fromDirectory ./packages;
  vimPlugins = fromDirectory ./vim-plugins;
  overrides = import ./overrides.nix final prev;

  vimPluginsPrefixed = lib.mapAttrs' (name: value: {
    name = "vimplugin-${name}";
    inherit value;
  }) vimPlugins;

in
lib.mergeAttrsList [
  (args.inputs.nix-darwin.overlays.default final prev)
  (import ./inputs.nix args final prev)
  (import ./hotfixes.nix final prev)
  {
    customPackages = packages // vimPluginsPrefixed // overrides;
    vimPlugins = prev.vimPlugins // vimPlugins;
  }
  functions
  packages
  overrides
]
