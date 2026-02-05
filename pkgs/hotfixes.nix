final: prev:
{
}
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  # https://hydra.nixos.org/job/nixpkgs/unstable/swift.aarch64-darwin
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/unstable/pam-watchid.aarch64-darwin
    pam-watchid
    # https://hydra.nixos.org/job/nixpkgs/unstable/pre-commit.aarch64-darwin
    pre-commit
    ;
})
