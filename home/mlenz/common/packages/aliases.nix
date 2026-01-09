{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkNodeApp =
    name: values:
    pkgs.writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' pkgs.nodejs "npx"} \
          ${toString (map (v: "--package ${v}") values)} \
          ${name} "$@"
      '';
    };
  mkPythonApp =
    name: values:
    pkgs.writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' pkgs.uv-bin "uvx"} \
          --python ${lib.getExe pkgs.python3} \
          ${toString (map (v: "--from ${v}") values)} \
          ${name} "$@"
      '';
    };
in
lib.mkIf config.custom.profile.isWorkstation {
  home.packages =
    (lib.mapAttrsToList mkNodeApp {
      copilot = [ "@github/copilot" ];
      gemini = [ "@google/gemini-cli" ];
      icloud-photos-sync = [ "icloud-photos-sync" ];
      mcp-inspector = [ "@modelcontextprotocol/inspector" ];
    })
    ++ (lib.mapAttrsToList mkPythonApp {
      arguebuf = [ "arguebuf[cli]" ];
      pyrefly = [ "pyrefly" ];
      ast-grep-server = [ "git+https://github.com/ast-grep/ast-grep-mcp" ];
    });
}
