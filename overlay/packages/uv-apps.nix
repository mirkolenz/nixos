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
        exec ${lib.getExe uv-bin} tool run ${value}@latest "$@"
      '';
    };
in
symlinkJoin {
  name = "uv-apps";
  paths = lib.mapAttrsToList mkUvApp {
    arguebuf = "arguebuf";
  };
}
