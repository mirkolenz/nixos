{
  lib,
  symlinkJoin,
  writeShellApplication,
  uv-bin,
  python3,
}:
let
  mkUvApp =
    name: values:
    writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' uv-bin "uvx"} \
          --python ${lib.getExe python3} \
          ${toString (map (value: "--from ${value}") values)} \
          ${name} "$@"
      '';
    };
in
symlinkJoin {
  name = "uv-apps";
  paths = lib.mapAttrsToList mkUvApp {
    arguebuf = [ "arguebuf[cli]" ];
    pyrefly = [ "pyrefly" ];
    ast-grep-server = [ "git+https://github.com/ast-grep/ast-grep-mcp" ];
  };
}
