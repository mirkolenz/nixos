final: prev:
{
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/libraspberrypi.aarch64-linux
    libraspberrypi
    ;
}
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/gitui.aarch64-darwin
    gitui
    ;
})
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  ncdu = final.empty;
})
