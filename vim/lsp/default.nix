{ lib', lib, ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      astro.enable = true;
      bashls.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      html.enable = true;
      java_language_server.enable = true;
      jsonls.enable = true;
      ruff.enable = true;
      ts_ls.enable = true;
      tinymist.enable = true;
      yamlls.enable = true;
    };
  };
  keymaps =
    map
      (
        attrs:
        attrs
        // {
          action = lib.nixvim.mkRaw "function() vim.lsp.${attrs.action} end";
          mode = attrs.mode or "n";
        }
      )
      [
        {
          key = "<leader>lf";
          action = "buf.format()";
          options.desc = "Format buffer";
        }
      ];
}
