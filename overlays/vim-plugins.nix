{ ... }:
final: prev:
let
  inherit (prev) lib;
in
{
  vimPlugins =
    (prev.vimPlugins or { })
    // (lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ./vim-plugins;
    });
}
