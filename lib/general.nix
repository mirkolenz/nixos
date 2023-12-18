lib: {
  getModules = dir: let
    toImport = name: value: dir + ("/" + name);
    filterFiles = name: value:
      !lib.hasPrefix "_" name
      && (
        (value == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
        || value == "directory"
      );
  in
    lib.mapAttrsToList toImport (lib.filterAttrs filterFiles (builtins.readDir dir));
  optionalPath = path:
    if builtins.pathExists path
    then [path]
    else [];
  isEmpty = value: value == null || value == "" || value == [] || value == {};
  isNotEmpty = value: !(value == null || value == "" || value == [] || value == {});
  isEnabled = x: builtins.hasAttr "enable" x && x.enable == true;
  githubSshKeys = {
    user,
    sha256,
  }: let
    apiResponse = builtins.fetchurl {
      inherit sha256;
      url = "https://api.github.com/users/${user}/keys";
    };
    parsedResponse = builtins.fromJSON (builtins.readFile apiResponse);
  in
    builtins.map (x: x.key) parsedResponse;
  getLeaves = let
    getLeavesPath = attrs: path:
      if builtins.isAttrs attrs
      then
        builtins.concatLists (
          lib.mapAttrsToList
          (key: value: getLeavesPath value (path ++ [key]))
          attrs
        )
      else [
        {
          name = builtins.concatStringsSep "." path;
          value = attrs;
        }
      ];
  in
    attrs: builtins.listToAttrs (getLeavesPath attrs []);
  attrByDottedPath = path: lib.attrByPath (lib.splitString "." path);
  getAttrFromDottedPath = path: lib.getAttrFromPath (lib.splitString "." path);
  setAttrByDottedPath = path: lib.setAttrByPath (lib.splitString "." path);
}
