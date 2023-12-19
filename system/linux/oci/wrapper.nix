{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.oci;
  wrapperCfg = cfg.shellWrapper;
  cli = import ./containers/cli.nix lib;

  podmanArgs =
    (cli.mkOptions {
      rm = true;
      subuidname = cfg.subidname;
      subgidname = cfg.subidname;
    })
    ++ (cli.mkEnv {})
    ++ (cli.mkHosts {})
    ++ (cli.mkCaps {})
    ++ (cli.mkSysctls {});
in {
  options.custom.oci.shellWrapper = with lib; {
    enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = lib.mkIf (cfg.enable && wrapperCfg.enable) {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "oci-run";
        text = ''
          exec sudo ${lib.getExe pkgs.podman} run ${lib.escapeShellArgs podmanArgs} "$@"
        '';
      })
    ];
  };
}
