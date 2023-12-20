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
    })
    ++ (cli.mkSubidname cfg.subidname)
    ++ (cli.mkEnv {})
    ++ (cli.mkHosts {})
    ++ (cli.mkCaps {})
    ++ (cli.mkSysctls {});

  wrapper = pkgs.writeShellApplication {
    name = "oci";
    text = ''
      if [ "$#" -eq 0 ]; then
        echo "Usage: oci <command> [<args>]"
        echo ""
        echo "Available commands:"
        echo "exec: Run a command in an existing container"
        echo "run: Run a command in a new container"
        echo "service: Control the systemd service"
        echo "journal: Show the logs of the podman service"
        exit 1
      fi
      if [ "$1" -eq "run" ]; then
        exec sudo ${lib.getExe pkgs.podman} run ${lib.escapeShellArgs podmanArgs} "''${@:2}"
      fi
      if [ "$1" -eq "exec" ]; then
        exec sudo ${lib.getExe pkgs.podman} exec "''${@:2}"
      fi
      if [ "$1" -eq "service" ]; then
        exec sudo systemctl "''${3:-status}" "podman-$2.service" "''${@:}"
      fi
      if [ "$1" -eq "journal" ]; then
        exec sudo journalctl --unit "podman-$2.service" "''${@:3}"
      fi
    '';
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
      wrapper
    ];
  };
}
