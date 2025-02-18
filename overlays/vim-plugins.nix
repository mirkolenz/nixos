{ ... }:
final: prev: {
  vimPlugins =
    prev.vimPlugins
    // prev.lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ./vim-plugins;
    };
}
