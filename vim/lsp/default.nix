{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins.lspconfig.enable = true;
  lsp = {
    inlayHints.enable = true;
    servers = {
      astro.enable = true;
      bashls.enable = true;
      buf_ls.enable = true;
      cssls.enable = true;
      copilot.enable = true;
      docker_language_server.enable = true;
      gopls.enable = true;
      java_language_server.enable = true;
      tailwindcss.enable = true;
      tombi.enable = true;
      tsgo.enable = true;
      yamlls.enable = true;
    };
  };
}
