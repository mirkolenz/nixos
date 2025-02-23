{ quadletCfg }:
{
  lib,
  config,
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
    virtualHost =
      let
        networkRef = quadletCfg.proxy.networks.internal.ref;
        networkEntry = lib.findSingle (
          network: lib.hasPrefix "${networkRef}:" network
        ) "" "" config.containerConfig.Network;
        matches = lib.match "ip=([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+)" networkEntry;
        ip = if matches != null && lib.length matches > 0 then lib.head matches else null;
      in
      {
        reverseProxy.upstreams = lib.mkIf (ip != null) [ ip ];
      };
  };
}
