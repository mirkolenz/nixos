{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.oci;
  wrapperCfg = cfg.shellWrapper;
  mkOptions = import ./containers/cli.nix lib;

  podmanArgs = mkOptions {
    rm = true;
    subuidname = cfg.subidname;
    subgidname = cfg.subidname;
    cap-add = ["NET_RAW" "NET_BIND_SERVICE"];
    sysctl = [
      (lib.nameValuePair "net.ipv4.ip_unprivileged_port_start" 0)
    ];
    env = [
      (lib.nameValuePair "TZ" "Europe/Berlin")
    ];
  };
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
