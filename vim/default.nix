# https://nix-community.github.io/nixvim/
args @ {lib, ...}: let
  mergeModules = start: modules: lib.foldl (a: b: lib.recursiveUpdate a b) start modules;
  importModule = path: import path args;
  modules = lib.flocken.getModules ./.;
  importedModules = builtins.map importModule modules;
in
  mergeModules
  {
    filetype.extension = {
      astro = "astro";
    };
  }
  importedModules
