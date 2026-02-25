final: prev:
let
  pkgs = final.nixpkgs;
in
pkgs.caddy.withPlugins {
  plugins = [
    # https://github.com/caddy-dns/cloudflare/tags
    "github.com/caddy-dns/cloudflare@v0.2.3"
  ];
  hash = "sha256-mmkziFzEMBcdnCWCRiT3UyWPNbINbpd3KUJ0NMW632w=";
}
