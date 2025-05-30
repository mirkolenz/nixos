{ ... }:
{
  lsp.servers.nixd = {
    enable = true;
    settings.settings = {
      formatting.command = [ "nixfmt" ];
      nixpkgs.expr = "import (builtins.getFlake (\"git:\" + builtins.toString ./.)).inputs.nixpkgs { }";
    };
  };
}
