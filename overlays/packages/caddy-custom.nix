{ caddy }:
caddy.withPlugins {
  plugins = [
    "github.com/caddy-dns/cloudflare@89f16b99c18ef49c8bb470a82f895bce01cbaece"
  ];
  hash = "sha256-WGV/Ve7hbVry5ugSmTYWDihoC9i+D3Ct15UKgdpYc9U=";
}
