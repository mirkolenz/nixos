{ inputs, ... }:
final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;
  inherit (prev) lib;
  exportedFunctions = {
    mkApp = final.callPackage ./functions/make-app.nix { };
    mkBuilder = final.callPackage ./functions/make-builder.nix { };
    mkDocker = final.callPackage ./functions/make-docker.nix { };
    linkExe = final.callPackage ./functions/link-exe.nix { };
  };
  exportedPackages = lib.packagesFromDirectoryRecursive {
    # inherit (prev) newScope;
    callPackage = lib.callPackageWith (final // { inherit inputs; });
    directory = ./packages;
  };
in
{
  exported-functions = exportedFunctions;
  exported-packages = lib.filterAttrs (
    name: value: lib.meta.availableOn { inherit system; } value && lib.isDerivation value
  ) exportedPackages;
  vimPlugins =
    prev.vimPlugins
    // prev.lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ./vim-plugins;
    };
}
// exportedFunctions
// exportedPackages
