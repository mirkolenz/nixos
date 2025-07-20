{ inputs, ... }:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  inherit (prev) lib;
  functions = lib.packagesFromDirectoryRecursive {
    # inherit (prev) newScope;
    callPackage = lib.callPackageWith (final // { inherit inputs; });
    directory = ./functions;
  };
  packages = lib.packagesFromDirectoryRecursive {
    # inherit (prev) newScope;
    callPackage = lib.callPackageWith (final // { inherit inputs; });
    directory = ./packages;
  };
  vimPlugins = prev.lib.packagesFromDirectoryRecursive {
    inherit (prev) callPackage;
    directory = ./vim-plugins;
  };
  vimPluginsPrefixed = lib.mapAttrs' (name: value: {
    name = "vimplugin-${name}";
    inherit value;
  }) vimPlugins;
in
{
  custom-packages = lib.filterAttrs (
    name: value: lib.meta.availableOn { inherit system; } value && lib.isDerivation value
  ) (packages // vimPluginsPrefixed);
  vimPlugins = prev.vimPlugins // vimPlugins;
}
// functions
// packages
