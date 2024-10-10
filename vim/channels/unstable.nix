{ ... }:
{
  plugins.treesitter.settings.indent.enable = true;
  plugins.lsp.servers = {
    ts_ls.enable = true;
    ruff_lsp.enable = true;
    java_language_server.enable = true;
    nil_ls = {
      enable = false;
      settings = {
        formatting.command = [ "nixfmt" ];
      };
    };
  };
  plugins.web-devicons.enable = true;
}
