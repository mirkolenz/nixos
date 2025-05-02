{ ... }:
{
  lsp.servers.basedpyright = {
    enable = true;
    settings.basedpyright = {
      typeCheckingMode = "standard";
      analysis = {
        diagnosticMode = "workspace";
        useLibraryCodeForTypes = false;
      };
    };
  };
}
