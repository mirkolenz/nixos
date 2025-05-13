{ ... }:
{
  lsp.servers.basedpyright = {
    enable = true;
    settings.settings.basedpyright = {
      typeCheckingMode = "standard";
      analysis = {
        diagnosticMode = "workspace";
        useLibraryCodeForTypes = false;
      };
    };
  };
}
