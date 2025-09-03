{
  lib,
  writers,
  python3Packages,
  darwin-rebuild,
  nixos-rebuild-ng,
  home-manager,
  determinate-nix,
}:
(writers.writePython3Bin "builder" {
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
        (lib.getExe nixos-rebuild-ng)
        "--home-builder"
        (lib.getExe home-manager)
        "--nix-exe"
        (lib.getExe determinate-nix)
      ];
} ./script.py).overrideAttrs
  (oldAttrs: {
    meta = (oldAttrs.meta or { }) // {
      githubActionsCheck = true;
    };
  })
