{ ... }:
{
  plugins.lsp.servers.basedpyright = {
    enable = true;
    settings.basedpyright = {
      typeCheckingMode = "standard";
      analysis = {
        diagnosticMode = "openFilesOnly";
        inlayHints = {
          genericTypes = true;
        };
      };
    };
  };
}
