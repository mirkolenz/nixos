{ quadletCfg, writeShellApplication }:
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
    imageFile = mkOption {
      type = with types; nullOr package;
      default = null;
    };
    imageStream = mkOption {
      type = with types; nullOr package;
      default = null;
    };

    virtualHost =
      let
        networkRef = quadletCfg.proxy.networks.internal.ref;
        networkConfig = lib.findSingle (
          network: lib.hasPrefix "${networkRef}:" network
        ) "" "" config.containerConfig.networks;
        matches = lib.match "ip=([[:digit:].]+)" networkConfig;
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
  config =
    let
      prestart = writeShellApplication {
        name = "prestart";
        text = ''
          ${lib.optionalString (config.imageFile != null) ''
            podman load -i ${config.imageFile}
          ''}
          ${lib.optionalString (config.imageStream != null) ''
            ${config.imageStream} | podman load
          ''}
        '';
      };
    in
    {
      serviceConfig = {
        ExecStartPre = [ (lib.getExe prestart) ];
      };
    };
}
