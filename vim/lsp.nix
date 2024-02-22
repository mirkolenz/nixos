{ ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      astro.enable = true;
      bashls.enable = true;
      cssls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      html.enable = true;
      java-language-server.enable = true;
      jsonls.enable = true;
      ltex.enable = true;
      nil_ls = {
        enable = true;
        settings.formatting.command = [ "nixfmt" ];
      };
      nixd = {
        enable = false;
        settings = {
          formatting.command = "nixfmt";
          options.enable = false;
        };
      };
      pyright.enable = true;
      ruff-lsp.enable = true;
      tsserver.enable = true;
      yamlls.enable = true;
    };
  };
}
