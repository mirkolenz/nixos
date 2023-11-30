lib: {
  # https://github.com/infinisil/system/blob/b8bbfde10411ae7a673ac49c60efce56f3c2bc57/config/new-modules/default.nix
  importFolder = dir: let
    toImport = name: value: dir + ("/" + name);
    filterFiles = name: value:
      (value == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
      || value == "directory";
    imports = lib.mapAttrsToList toImport (lib.filterAttrs filterFiles (builtins.readDir dir));
  in
    imports;
  checkSudo = ''
    SUDO=""
    if [ "$(id -u)" -ne 0 ]; then
        SUDO="sudo"
    fi
  '';
}
