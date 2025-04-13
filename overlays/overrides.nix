{ ... }:
final: prev: {
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus jujutsu;
  inherit (final.stable) php;
}
