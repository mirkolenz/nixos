{ ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      astro.enable = true;
      bashls.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      html.enable = true;
      jsonls.enable = true;
      ltex.enable = true;
      nixd = {
        enable = true;
        settings = {
          formatting.command = [ "nixfmt" ];
        };
      };
      pyright.enable = true;
      yamlls.enable = true;
    };
  };
}
