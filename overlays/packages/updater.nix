{ inputs, writeShellApplication }:
writeShellApplication {
  name = "updater";
  text = ''
    pathArg="$1"
    shift
    exec nix-shell \
      ${inputs.nixpkgs.outPath}/maintainers/scripts/update.nix \
      --arg include-overlays "[ (builtins.getFlake (\"git+file://\" + builtins.toString ./.)).overlays.default ]" \
      --argstr path "$pathArg" \
      "$@"
  '';
}
