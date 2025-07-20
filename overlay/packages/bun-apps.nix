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
        exec ${lib.getExe' bun "bunx"} --bun ${value}@latest "$@"
      '';
    };
in
symlinkJoin {
  name = "bun-apps";
  paths = lib.mapAttrsToList mkBunApp {
    ccusage = "ccusage";
    # claude = "@anthropic-ai/claude-code";
  };
}
