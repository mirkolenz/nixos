{
  lib,
  writers,
  python3Packages,
  inputs,
  determinate-nix,
}:
writers.writePython3Bin "updater" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs =
    lib.concatMap
      (x: [
        "--add-flag"
        x
      ])
      [
        "--nixpkgs"
        inputs.nixpkgs.outPath
        "--nix-shell"
        (lib.getExe' determinate-nix "nix-shell")
      ];
} ./script.py
