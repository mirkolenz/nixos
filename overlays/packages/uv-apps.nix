{
  lib,
  symlinkJoin,
  writeShellApplication,
  uv,
}:
let
  mkUvApp =
    name: value:
    writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' uv "uvx"} ${value}@latest "$@"
      '';
    };
in
symlinkJoin {
  name = "uv-apps";
  paths = lib.mapAttrsToList mkUvApp {
    pyrefly = "pyrefly";
    ty = "ty";
  };
}
