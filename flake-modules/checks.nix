{
  lib,
  self,
  inputs,
  ...
}:
let
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
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
    # https://docs.github.com/en/actions/how-tos/write-workflows/choose-where-workflows-run/choose-the-runner-for-a-job#standard-github-hosted-runners-for-public-repositories
    platforms = {
      "aarch64-darwin" = "macos-15";
      "aarch64-linux" = "ubuntu-24.04-arm";
      "x86_64-linux" = "ubuntu-24.04";
    };
  };
}
