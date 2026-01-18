{ pkgs, ... }:
{
  lsp.servers.ty = {
    enable = true;
    package = pkgs.ty-bin;
    config.settings = { };
  };
}
