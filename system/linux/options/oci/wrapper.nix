{
  lib,
  lib',
  pkgs,
  config,
  ...
}:
let
  cfg = config.custom.oci;
  wrapperCfg = cfg.shellWrapper;
  cli = import ./containers/cli.nix { inherit lib lib'; };

  podmanArgs =
    (cli.mkOptions { rm = true; })
    ++ (cli.mkUserns cfg.userns)
    ++ (cli.mkEnv { })
    ++ (cli.mkHosts { })
    ++ (cli.mkCaps { })
    ++ (cli.mkSysctls { });

  wrapper = pkgs.writeShellApplication {
    name = "oci";
    text = ''
      if [ "$#" -eq 0 ]; then
        set -- "help"
      fi
      if [ "$1" = "run" ]; then
        exec sudo ${lib.getExe pkgs.podman} run ${lib.escapeShellArgs podmanArgs} "''${@:2}"
      fi
      if [ "$1" = "exec" ]; then
        exec sudo ${lib.getExe pkgs.podman} exec "''${@:2}"
      fi
      if [ "$1" = "update" ]; then
        exec sudo ${lib.getExe pkgs.podman} auto-update "''${@:2}"
      fi
      if [ "$1" = "service" ]; then
        exec systemctl "''${3:-status}" "podman-$2.service" "''${@:4}"
      fi
      if [ "$1" = "journal" ]; then
        exec journalctl --pager-end --no-hostname --unit "podman-$2.service" "''${@:3}"
      fi
      if [ "$1" = "unshare" ]; then
        exec unshare --user --map-auto --setuid "$2" --setgid "$2" -- "''${@:3}"
      fi
      if [ "$1" = "help" ]; then
        echo "Usage: oci <command>

        Available commands:
        run <cmd>: Run a command in a new container
        exec <container> <cmd>: Run a command in an existing container
        update <args>: Run podman auto-update
        service <container> <action> <args>: Control the systemd service
        journal <container> <args>: Show the logs of the podman service
        unshare <id> <cmd>: Run a command in a new user namespace
        "
        exit 0
      fi
    '';
  };
in
{
  options.custom.oci.shellWrapper = with lib; {
    enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = lib.mkIf (cfg.enable && wrapperCfg.enable) { environment.systemPackages = [ wrapper ]; };
}
