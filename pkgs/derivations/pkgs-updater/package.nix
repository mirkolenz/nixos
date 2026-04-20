{
  lib,
  writers,
  python3Packages,
  determinate-nix,
  inputs,
}:
writers.writePython3Bin "pkgs-updater" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs = [
    "--add-flag"
    "--nixpkgs=${inputs.nixpkgs.outPath}"
    "--add-flag"
    "--nix-shell=${lib.getExe' determinate-nix "nix-shell"}"
  ];
} ./script.py
