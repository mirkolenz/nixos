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
