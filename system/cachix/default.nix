{lib, ...}: let
  importFolder = folder: let
    toImport = name: value: folder + ("/" + name);
    filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key && key != "default.nix";
  in
    lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in {
  imports = importFolder ./.;
  # nix.settings.substituters = ["https://cache.nixos.org"];
}
