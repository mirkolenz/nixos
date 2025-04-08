{ ... }:
final: prev: {
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus jujutsu;
}
