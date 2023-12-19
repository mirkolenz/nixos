{
  lib,
  pkgs,
  config,
  options,
  ...
}: let
  cfg = config.custom.oci;
  getDefault = attr: options.custom.oci.containers.${attr}.default;
  wrapperCfg = cfg.shellWrapper;
  cli = import ./containers/cli.nix lib;

  podmanArgs =
    (cli.mkOptions {
      rm = true;
      subuidname = getDefault "subidname";
      subgidname = getDefault "subidname";
      env = lib.attrsToList (getDefault "environment");
    })
    ++ (cli.mkHosts (getDefault "hosts"))
    ++ (cli.mkCaps (getDefault "caps"))
    ++ (cli.mkSysctls (getDefault "sysctls"));
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
