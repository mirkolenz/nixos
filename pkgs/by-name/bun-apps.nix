{
  lib,
  symlinkJoin,
  writeShellApplication,
  bun,
}:
let
  mkBunApp =
    name: value:
    writeShellApplication {
      inherit name;
      text = ''
        exec ${lib.getExe' bun "bunx"} --bun ${value} "$@"
      '';
    };
in
symlinkJoin {
  name = "bun-apps";
  paths = lib.mapAttrsToList mkBunApp {
    copilot = "@github/copilot";
    gemini = "@google/gemini-cli";
    icloud-photos-sync = "icloud-photos-sync";
    mcp-inspector = "@modelcontextprotocol/inspector";
  };
}
