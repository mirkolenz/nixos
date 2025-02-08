{
  lib,
  writeShellApplication,
  config-builder,
  darwin-rebuild,
  nixos-rebuild,
  home-manager,
}:
{
  flake,
  args ? [ ],
}:
writeShellApplication {
  name = "config-builder";
  text = ''
    exec ${lib.getExe config-builder} \
      --darwin-builder ${lib.getExe darwin-rebuild} \
      --linux-builder ${lib.getExe nixos-rebuild} \
      --home-builder ${lib.getExe home-manager} \
      --flake ${flake} \
      ${lib.escapeShellArgs args} \
      "$@"
  '';
}
