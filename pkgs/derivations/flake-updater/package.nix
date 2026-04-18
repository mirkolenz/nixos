{
  lib,
  writers,
  python3Packages,
  gh,
  git,
  determinate-nix,
}:
writers.writePython3Bin "flake-updater" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs =
    lib.concatMap
      (x: [
        "--add-flag"
        x
      ])
      [
        "--gh-exe"
        (lib.getExe gh)
        "--git-exe"
        (lib.getExe git)
        "--nix-exe"
        (lib.getExe determinate-nix)
      ];
} ./script.py
