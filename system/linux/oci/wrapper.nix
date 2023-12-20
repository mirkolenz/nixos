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
      if [ "$1" = "run" ]; then
        exec sudo ${lib.getExe pkgs.podman} run ${lib.escapeShellArgs podmanArgs} "''${@:2}"
      fi
      if [ "$1" = "exec" ]; then
        exec sudo ${lib.getExe pkgs.podman} exec "''${@:2}"
      fi
      if [ "$1" = "service" ]; then
        exec sudo systemctl "''${3:-status}" "podman-$2.service" "''${@:4}"
      fi
      if [ "$1" = "journal" ]; then
        exec sudo journalctl --unit "podman-$2.service" "''${@:3}"
      fi
      if [ "$1" = "unshare" ]; then
        exec unshare --user --map-auto --setuid "$2" --setgid "$2" -- "''${@:3}"
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
