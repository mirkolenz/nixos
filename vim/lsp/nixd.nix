{ ... }:
{
  plugins.lsp.servers.nixd = {
    enable = true;
    settings = {
      formatting.command = [ "nixfmt" ];
    };
  };
}
