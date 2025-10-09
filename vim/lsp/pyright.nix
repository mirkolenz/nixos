{ ... }:
{
  lsp.servers.basedpyright = {
    enable = true;
    config.settings.basedpyright = {
      typeCheckingMode = "standard";
      analysis = {
        diagnosticMode = "workspace";
        useLibraryCodeForTypes = false;
      };
    };
  };
}
