{ pkgs, ... }:
{
  lsp.servers.ruff = {
    enable = true;
    package = pkgs.ty-bin;
  };
}
