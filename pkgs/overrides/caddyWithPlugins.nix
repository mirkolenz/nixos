final: prev:
final.nixpkgs.caddy.withPlugins {
  plugins = [
    # https://github.com/caddy-dns/cloudflare/tags
    "github.com/caddy-dns/cloudflare@v0.2.1"
  ];
  hash = "sha256-aRMg7R0dBAy+LJeGCMPg6HKppM6NPX2NPwtc0CeSQLg=";
}
