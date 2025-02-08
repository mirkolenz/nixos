{ ... }:
final: prev: {
  nixfmt = final.nixfmt-rfc-style;
  inherit (final.nixpkgs) caddy;
}
