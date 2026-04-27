{
  lib,
  writers,
  python3Packages,
  darwin-rebuild,
  nixos-rebuild-ng,
  home-manager,
  determinate-nix,
}:
writers.writePython3Bin "config-builder" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs = [
    "--add-flag"
    "--darwin-builder=${lib.getExe darwin-rebuild}"
    "--add-flag"
    "--linux-builder=${lib.getExe nixos-rebuild-ng}"
    "--add-flag"
    "--home-builder=${lib.getExe home-manager}"
    "--add-flag"
    "--nix-exe=${lib.getExe determinate-nix}"
  ];
} ./script.py
