{ ... }:
final: prev:
{
  # https://github.com/NixOS/nixpkgs/issues/438765#issuecomment-3281041188
  tailscale = prev.tailscale.overrideAttrs { doCheck = false; };
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/trunk/buf.x86_64-darwin
    buf
    ;
}
// (prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-darwin") {
  ncdu = final.empty;
})
