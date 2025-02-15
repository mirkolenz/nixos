{ pkgs, ... }:
{
  plugins.lsp = {
    enable = true;
    inlayHints = true;
    servers = {
      astro.enable = true;
      basedpyright = {
        enable = true;
        settings.basedpyright = {
          typeCheckingMode = "standard";
          analysis = {
            diagnosticMode = "workspace";
            inlayHints = {
              genericTypes = true;
            };
          };
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
        settings.ltex = {
          language = "en-US";
          additionalRules.motherTongue = "de-DE";
        };
      };
      nixd = {
        enable = true;
        settings = {
          formatting.command = [ "nixfmt" ];
        };
      };
      ruff.enable = true;
      ts_ls.enable = true;
      texlab = {
        enable = true;
        settings.texlab = {
          bibtexFormatter = "tex-fmt";
          latexFormatter = "tex-fmt";
          inlayHints = {
            labelDefinitions = false;
            labelReferences = false;
            maxLength = 32;
          };
          build = {
            onSave = false;
            forwardSearchAfter = true;
          };
          # https://github.com/latex-lsp/texlab/wiki/Previewing
          # https://github.com/rzukic/zed-latex/blob/main/src/preview_presets.rs
          forwardSearch =
            if pkgs.stdenv.isDarwin then
              {
                # displayline -h
                executable = "displayline";
                args = [
                  "-r"
                  "-g"
                  "%l"
                  "%p"
                  "%f"
                ];
              }
            else
              {
                executable = "sioyek";
                args = [
                  "--reuse-window"
                  "--nofocus"
                  "--execute-command"
                  "turn_on_synctex"
                  "--forward-search-file"
                  "%f"
                  "--forward-search-line"
                  "%l"
                  "%p"
                ];
              };
        };
      };
      tinymist.enable = true;
      yamlls.enable = true;
    };
  };
}
