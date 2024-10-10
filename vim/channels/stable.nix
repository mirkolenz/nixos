{ ... }:
{
  plugins.treesitter.indent = true;
  plugins.lsp.servers = {
    tsserver.enable = true;
    java-language-server.enable = true;
    nil-ls = {
      enable = false;
      settings = {
        formatting.command = [ "nixfmt" ];
      };
    };
    ruff-lsp.enable = true;
  };
}
