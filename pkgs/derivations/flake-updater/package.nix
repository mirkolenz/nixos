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
  makeWrapperArgs = [
    "--add-flag"
    "--gh-exe=${lib.getExe gh}"
    "--add-flag"
    "--git-exe=${lib.getExe git}"
    "--add-flag"
    "--nix-exe=${lib.getExe determinate-nix}"
  ];
} ./script.py
