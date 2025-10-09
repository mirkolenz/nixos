{ ... }:
{
  lsp.servers.nixd = {
    enable = true;
    config.settings = {
      formatting.command = [ "nixfmt" ];
      nixpkgs.expr = "import (builtins.getFlake \"nixpkgs\") { }";
    };
  };
}
