{ lib, ... }:
{
  options.custom.nix = {
    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
    };
  };
}
