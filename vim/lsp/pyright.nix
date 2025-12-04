{ ... }:
{
  lsp.servers.basedpyright = {
    enable = true;
    config.settings.basedpyright = {
      analysis = {
        typeCheckingMode = "standard";
        diagnosticMode = "workspace";
        useLibraryCodeForTypes = false;
      };
    };
  };
}
