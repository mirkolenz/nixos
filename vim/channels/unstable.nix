{ ... }:
{
  plugins.lsp.servers.dockerls.enable = true;
  plugins.telescope.extensions.file-browser.enable = true;
  plugins.comment.enable = true;
  plugins.lsp.servers.nixd.settings.formatting.command = [ "nixfmt" ];
}
