{ inputs, ... }:
final: prev:
let
  inherit (prev) lib;

  fromDirectory =
    directory:
    lib.packagesFromDirectoryRecursive {
      callPackage = lib.callPackageWith (final // { inherit inputs; });
      inherit directory;
    };

  functions = fromDirectory ./functions;
  packages = fromDirectory ./packages;
  vimPlugins = fromDirectory ./vim-plugins;
  vimPluginsPrefixed = lib.mapAttrs' (name: value: {
    name = "vimplugin-${name}";
    inherit value;
  }) vimPlugins;
in
{
  customPackages = packages // vimPluginsPrefixed;
  vimPlugins = prev.vimPlugins // vimPlugins;
}
// functions
// packages
