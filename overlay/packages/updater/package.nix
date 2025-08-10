{
  lib,
  writers,
  python3Packages,
  inputs,
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
      ];
} ./script.py
