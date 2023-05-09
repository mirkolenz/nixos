{ lib, config, osConfig, pkgs, extras, ... }:
let
  username = "mlenz";
  homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  exaArgs = "--long --icons --group-directories-first --git --color=always --time-style=long-iso";
in
{
  imports = [
    ./xserver.nix
    ./programs
    ./files
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    inherit username;
    inherit (extras) stateVersion;
    homeDirectory = lib.mkDefault homeDirectory;
    shellAliases = {
      cat = "bat";
      ls = "exa";
      ll = "exa ${exaArgs}";
      la = "exa --all ${exaArgs}";
      l = "exa ${exaArgs}";
      top = "btm";
      dc = "sudo docker compose";
      py = "poetry run python";
      hass = "hass-cli";
      nixos-env = "sudo nix-env --profile /nix/var/nix/profiles/system";
      poetryup = "/run/current-system/sw/bin/poetry up";
      npmup = "npx npm-check-updates";
      docker-reset = "docker system prune --all --force";
    };
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
    packages = with pkgs; [
      (writeShellApplication {
        name = "gc";
        text = ''
          nix store optimise
          nix store gc
          nix-collect-garbage --delete-older-than 30d
        '';
      })
      # https://github.com/NixOS/nixpkgs/blob/nixos-22.11/nixos/modules/tasks/auto-upgrade.nix#L204
      (writeShellApplication {
        name = "needs-reboot";
        runtimeInputs = [ coreutils ];
        text = ''
          booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

          if [ "$booted" != "$built" ]; then
            echo "REBOOT NEEDED"
          fi
        '';
      })
      (writeShellApplication {
        name = "dcup";
        text = ''
          if [ "$#" -ne 1 ]; then
            echo "Usage: $0 FILE" >&2
            exit 1
          fi
          if [ "$(id -u)" -ne 0 ]; then
            echo "Please run as root"
            exit 1
          fi
          docker compose --file "$1" pull
          docker compose --file "$1" build
          docker compose --file "$1" up --detach
          docker image prune --all --force
        '';
      })
      (writeShellApplication {
        name = "encrypt";
        text = ''
          if [ "$#" -ne 3 ]; then
            echo "Usage: $0 SOURCE TARGET RECIPIENT" >&2
            exit 1
          fi

          gpg --output "$2" --encrypt --recipient "$3" "$1"
        '';
      })
      (writeShellApplication {
        name = "decrypt";
        text = ''
          if [ "$#" -ne 2 ]; then
            echo "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi

          gpg --output "$2" --decrypt "$1"
        '';
      })
      (writeShellApplication {
        name = "backup";
        text = ''
          if [ "$#" -ne 2 ]; then
            echo "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi
          if [ "$(id -u)" -ne 0 ]; then
            echo "Please run as root"
            exit 1
          fi
          mkdir -p "$2"
          TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
          sudo tar czf "$2/$TIMESTAMP.tgz" "$1"
        '';
      })
      (writeShellApplication {
        name = "restore";
        text = ''
          if [ "$#" -ne 2 ]; then
            echo "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi
          if [ "$(id -u)" -ne 0 ]; then
            echo "Please run as root"
            exit 1
          fi
          mkdir -p "$2"
          sudo tar xf "$1" -C "$2"
        '';
      })
    ];
  };
}
