{ ... }:
final: prev: {
  nixfmt = final.nixfmt-rfc-style;
  inherit (final.nixpkgs) caddy;
  inherit (final.unstable-small) basedpyright;
  inherit (final.stable) makejinja;
  inherit (final.unstable) nixos-rebuild-ng ltex-ls-plus;
}
