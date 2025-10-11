{
  lib,
  writers,
  python3Packages,
  determinate-nix,
  nixpkgs,
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
        nixpkgs.path
        "--nix-shell"
        (lib.getExe' determinate-nix "nix-shell")
      ];
} ./script.py
