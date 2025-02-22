{ caddy }:
caddy.withPlugins {
  plugins = [
    "github.com/caddy-dns/cloudflare@v0.0.0-20250214163716-188b4850c0f2"
  ];
  hash = "sha256-izuQXvxIq3ycxcUuMErz7MbP9RwLkj+bhliK9H6Heqc=";
}
