{ inputs, ... }:
final: prev: {
  vimPlugins =
    prev.vimPlugins
    // prev.lib.packagesFromDirectoryRecursive {
      inherit (prev) callPackage;
      directory = ./vim-plugins;
    }
    // {
      inherit (inputs.blink-cmp.packages.${prev.stdenv.hostPlatform.system}) blink-cmp;
    };
}
