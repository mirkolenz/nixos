{
  lib,
  name,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = {
    virtualHost = mkOption {
      default = { };
      type = types.submodule ./_vhost.nix;
    };
  };
  config = {
    virtualHost.name = lib.mkDefault name;
  };
}
