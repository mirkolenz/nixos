{ caddy }:
caddy.withPlugins {
  plugins = [
    "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
  ];
  hash = "sha256-WGV/Ve7hbVry5ugSmTYWDihoC9i+D3Ct15UKgdpYc9U=";
}
