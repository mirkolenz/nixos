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
    "gibo"
    "hkknx-bin"
    "infat-bin"
    "janice"
    "nixvim-full"
    "protobuf-ls"
    "ty-bin"
    "updater"
    "uv-migrator"
    "wol"
  ];
in
{
  flake.githubActions = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.getAttrs systems (
      lib.mapAttrs (
        system: pkgs:
        lib.listToAttrs (
          map (name: {
            inherit name;
            value = pkgs.${name};
          }) packages
        )
      ) self.packages
    );
  };
}
