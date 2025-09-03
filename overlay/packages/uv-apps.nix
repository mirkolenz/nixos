{
  lib,
  symlinkJoin,
  writeShellApplication,
  uv-bin,
}:
let
  mkUvApp =
    name: value:
    writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' uv-bin "uvx"} ${value} "$@"
      '';
    };
in
symlinkJoin {
  name = "uv-apps";
  paths = lib.mapAttrsToList mkUvApp {
    arguebuf = "arguebuf";
    pyrefly = "pyrefly";
  };
}
