{ ... }:
final: prev:
{
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/buf.x86_64-darwin
    buf
    ;
}
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  ncdu = final.empty;
})
