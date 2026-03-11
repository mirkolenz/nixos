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
  inherit (final.stable)
    # https://hydra.nixos.org/job/nixpkgs/unstable/ast-grep.aarch64-darwin
    ast-grep
    # https://hydra.nixos.org/job/nixpkgs/unstable/caddy.aarch64-darwin
    caddy
    ;
})
