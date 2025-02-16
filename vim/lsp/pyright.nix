{ ... }:
{
  plugins.lsp.servers.basedpyright = {
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
}
