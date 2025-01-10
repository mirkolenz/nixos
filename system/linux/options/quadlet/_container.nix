{ quadletCfg }:
{
  lib,
  config,
  name,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = {
    virtualHost =
      let
        networkRef = quadletCfg.proxy.networks.internal.ref;
        networkEntry = lib.findSingle (
          network: lib.hasPrefix "${networkRef}:" network
        ) "" "" config.containerConfig.Network;
        matches = lib.match "ip=([[:digit:].]+)" networkEntry;
        ip = if matches != null && lib.length matches > 0 then lib.head matches else null;
      in
      mkOption {
        default = { };
        type = types.submodule (
          import ./_vhost.nix {
            inherit name lib;
            defaultUpstreams = if ip == null then [ ] else [ ip ];
          }
        );
      };
  };
}
