{ ... }:
{
  plugins.telescope.extensions.file_browser.enable = true;
  plugins.comment-nvim.enable = true;
  plugins.lsp.servers.nixd.settings.formatting.command = "nixfmt";
}
