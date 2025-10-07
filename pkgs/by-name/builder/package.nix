{
  lib,
  writers,
  python3Packages,
  darwin-rebuild,
  nixos-rebuild-ng,
  home-manager,
  determinate-nix,
}:
let
  nixos-rebuild-ng-determinate = nixos-rebuild-ng.override {
    nix = determinate-nix;
  };
in
writers.writePython3Bin "builder" {
  libraries = with python3Packages; [ typer ];
  doCheck = false;
  makeWrapperArgs =
    lib.concatMap
      (x: [
        "--add-flag"
        x
      ])
      [
        "--darwin-builder"
        (lib.getExe darwin-rebuild)
        "--linux-builder"
        (lib.getExe nixos-rebuild-ng-determinate)
        "--home-builder"
        (lib.getExe home-manager)
        "--nix-exe"
        (lib.getExe determinate-nix)
      ];
} ./script.py
