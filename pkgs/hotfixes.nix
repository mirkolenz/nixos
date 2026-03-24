final: prev:
{ }
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/unstable/direnv.aarch64-darwin
    direnv
    ;
})
