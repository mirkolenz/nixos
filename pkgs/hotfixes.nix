final: prev:
{
}
// (prev.lib.optionalAttrs prev.stdenv.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.isDarwin {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/unstable/swift.aarch64-darwin
    pam-watchid
    pre-commit
    ;
})
