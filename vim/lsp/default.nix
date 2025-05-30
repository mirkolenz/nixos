{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins.lspconfig.enable = true;
  lsp = {
    inlayHints.enable = true;
    servers = {
      astro.enable = true;
      bashls.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      harper_ls.enable = true;
      html.enable = true;
      java_language_server.enable = true;
      jsonls.enable = true;
      ruff.enable = true;
      ts_ls.enable = true;
      tinymist.enable = true;
      yamlls.enable = true;
    };
  };
}
