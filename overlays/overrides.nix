{ ... }:
final: prev: {
  inherit (final.stable) makejinja;
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus;
}
