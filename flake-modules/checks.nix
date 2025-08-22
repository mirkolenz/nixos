{
  lib,
  self,
  inputs,
  ...
}:
let
  systems = [
    "x86_64-linux"
  ];
  packages = [
    "bibtex2cff"
    "bibtexbrowser"
    "builder"
    "caddy"
    "claude-code-bin"
    "codex-bin"
    "copilot-language-server"
    "crush"
    "gibo"
    "hkknx-bin"
    "infat"
    "janice"
    "nixvim-full"
    "protobuf-ls"
    "ruff-bin"
    "ty-bin"
    "updater"
    "uv-bin"
    "uv-migrator"
    "wol"
  ];
in
{
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems (
      lib.mapAttrs (
        system: pkgs: lib.getAttrs (lib.intersectLists packages (lib.attrNames pkgs)) pkgs
      ) self.packages
    );
  };
}
