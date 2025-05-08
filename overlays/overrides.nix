{ ... }:
final: prev: {
  inherit (final.unstable)
    codex
    jujutsu
    ltex-ls-plus
    nixos-rebuild-ng
    ;
  inherit (final.stable)
    git-annex
    ;
}
