{ ... }:
{
  lsp.servers.basedpyright = {
    enable = false;
    config.settings.basedpyright = {
      typeCheckingMode = "standard";
      analysis = {
        diagnosticMode = "workspace";
        useLibraryCodeForTypes = false;
      };
    };
  };
}
