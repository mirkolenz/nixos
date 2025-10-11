final: prev:
final.nixpkgs.caddy.withPlugins {
  plugins = [
    # https://github.com/caddy-dns/cloudflare/tags
    "github.com/caddy-dns/cloudflare@v0.2.1"
  ];
  hash = "sha256-AcWko5513hO8I0lvbCLqVbM1eWegAhoM0J0qXoWL/vI=";
}
