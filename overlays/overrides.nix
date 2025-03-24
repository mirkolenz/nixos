{ ... }:
final: prev: {
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus;
  inherit (final.stable) tectonic;
}
