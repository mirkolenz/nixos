{
  lib,
  writers,
  python3Packages,
  determinate-nix,
}:
writers.writePython3Bin "pkgs-builder" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs = [
    "--add-flag"
    "--nix-exe=${lib.getExe determinate-nix}"
  ];
} ./script.py
