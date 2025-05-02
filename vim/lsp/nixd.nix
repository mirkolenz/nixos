{ ... }:
{
  lsp.servers.nixd = {
    enable = true;
    settings = {
      formatting.command = [ "nixfmt" ];
      nixpkgs.expr = ''import (builtins.getFlake "github:mirkolenz/nixos").inputs.nixpkgs { }'';
    };
  };
}
