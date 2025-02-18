{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.virtualisation.quadlet.shellWrapper;

  wrapper = pkgs.writeShellApplication {
    name = "quadlet";
    text = ''
      if [ "$#" -eq 0 ]; then
        set -- "help"
      fi
      command="$1"
      shift
      if [ "$command" = "exec" ]; then
        exec sudo ${lib.getExe pkgs.podman} exec "$@"
      fi
      if [ "$command" = "update" ]; then
        exec sudo ${lib.getExe pkgs.podman} auto-update "$@"
      fi
      if [ "$command" = "service" ]; then
        exec systemctl "''${2:-status}" "$1.service" "''${@:3}"
      fi
      if [ "$command" = "journal" ]; then
        exec journalctl --pager-end --no-hostname --unit "$1.service" "''${@:2}"
      fi
      if [ "$command" = "unshare" ]; then
        exec unshare --user --map-auto --setuid "$1" --setgid "$1" -- "''${@:2}"
      fi
      if [ "$command" = "help" ]; then
        echo "Usage: quadlet <command>

        Available commands:
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
  options.virtualisation.quadlet.shellWrapper = with lib; {
    enable = mkOption {
      default = true;
      type = with types; bool;
    };
  };

  config = lib.mkIf (config.virtualisation.quadlet.enable && cfg.enable) {
    environment.systemPackages = [ wrapper ];
  };
}
