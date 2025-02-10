{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    servers = {
      astro.enable = true;
      basedpyright = {
        enable = true;
        settings = {
          basedpyright.analysis = {
            diagnosticMode = "workspace";
            inlayHints = {
              genericTypes = true;
            };
          };
          python.pythonPath = ".venv/bin/python";
        };
      };
      bashls.enable = true;
      cssls.enable = true;
      dockerls.enable = true;
      eslint.enable = true;
      gopls.enable = true;
      html.enable = true;
      java_language_server.enable = true;
      jsonls.enable = true;
      ltex_plus = {
        enable = true;
        package = pkgs.ltex-ls-plus;
      };
      nixd = {
        enable = true;
        settings = {
          formatting.command = [ "nixfmt" ];
        };
      };
      ruff.enable = true;
      ts_ls.enable = true;
      texlab.enable = true;
      yamlls.enable = true;
    };
  };
}
