{ inputs, writeShellApplication }:
writeShellApplication {
  name = "updater";
  text = ''
    pathArg="$1"
    shift
    overlays="
      let
        flake = builtins.getFlake (\"git+file://\" + toString ./.);
        overlay = import ./overlays {
          inherit (flake) inputs;
          self = flake;
          lib' = flake.lib;
        };
      in
      [ overlay ]
    "
    exec nix-shell \
      ${inputs.nixpkgs.outPath}/maintainers/scripts/update.nix \
      --arg include-overlays "$overlays" \
      --argstr path "$pathArg" \
      "$@"
  '';
}
