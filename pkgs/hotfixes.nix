final: prev:
{
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/unstable/jetbrains-mono.aarch64-darwin
    jetbrains-mono
    ;
}
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
})
// (prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
  # https://hydra.nixos.org/job/nixpkgs/unstable/yt-dlp.aarch64-darwin
  inherit (final.stable)
    yt-dlp
    ;
})
