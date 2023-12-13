lib: {
  importFolder = dir: let
    toImport = name: value: dir + ("/" + name);
    filterFiles = name: value:
      !lib.hasPrefix "_" name
      && (
        (value == "regular" && lib.hasSuffix ".nix" name && name != "default.nix")
        || value == "directory"
      );
  in
    lib.mapAttrsToList toImport (lib.filterAttrs filterFiles (builtins.readDir dir));
  checkSudo = ''
    SUDO=""
    if [ "$(id -u)" -ne 0 ]; then
        SUDO="sudo"
    fi
  '';
  mkPodmanExec = attrs:
    lib.concatLines
    (
      lib.mapAttrsToList
      (container: commands: ''podman exec ${container} /bin/sh -c "${lib.concatStringsSep " && " commands}"'')
      attrs
    );
  optionalImport = path:
    if builtins.pathExists path
    then [path]
    else [];
  isEmpty = value: value == null || value == "" || value == [] || value == {};
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
}
