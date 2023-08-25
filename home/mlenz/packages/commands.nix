{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  exaArgs = "--long --icons --group-directories-first --git --color=always --time-style=long-iso";
  echo = "${pkgs.coreutils}/bin/echo";
  nixup = ''
    exec ${lib.getExe pkgs.nix} flake update \
    --commit-lock-file \
    --commit-lockfile-summary 'chore(deps): update flake.lock' \
    "$@"
  '';
  checkSudo = ''
    SUDO=""
    if [ "$(id -u)" -ne 0 ]; then
      SUDO="sudo"
    fi
  '';
in {
  home = {
    shellAliases = with pkgs; {
      cat = "${lib.getExe bat}";
      ls = "${lib.getExe exa}";
      ll = "${lib.getExe exa} ${exaArgs}";
      la = "${lib.getExe exa} --all ${exaArgs}";
      l = "${lib.getExe exa} ${exaArgs}";
      sudo = lib.mkIf (osConfig == {}) "sudo --preserve-env=PATH env";
    };
    packages = with pkgs; [
      (writeShellApplication {
        name = "pull-rebuild";
        text = ''
          set -x #echo on
          FLAKE=''${1:-"github:mirkolenz/nixos"}

          if [[ "$FLAKE" != github* ]]; then
            ${lib.getExe git} -C "$FLAKE" pull
          fi

          exec ${lib.getExe nix} run "$FLAKE" -- "''${@:2}"
        '';
      })
      # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
      (writeShellApplication {
        name = "mogrify-convert";
        text = ''
          if [ "$#" -ne 3 ]; then
            ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY" >&2
            exit 1
          fi
          exec ${imagemagick}/bin/mogrify -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
        '';
      })
      # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
      (writeShellApplication {
        name = "mogrify-resize";
        text = ''
          if [ "$#" -ne 4 ]; then
            ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY FINAL_SIZE" >&2
            exit 1
          fi
          exec ${imagemagick}/bin/mogrify -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
        '';
      })
      (writeShellApplication {
        name = "gc";
        text = ''
          ${checkSudo}
          set -x #echo on
          "$SUDO" ${nix}/bin/nix-collect-garbage --delete-older-than 7d
          ${nix}/bin/nix-collect-garbage --delete-older-than 7d
          ${lib.getExe nix} store gc
          ${lib.getExe nix} store optimise
        '';
      })
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/tasks/auto-upgrade.nix#L204
      (writeShellApplication {
        name = "needs-reboot";
        text = ''
          booted="$(${coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(${coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

          if [ "$booted" != "$built" ]; then
            ${echo} "REBOOT NEEDED"
            exit 1
          fi

          exit 0
        '';
      })
      (writeShellApplication {
        name = "dc";
        text = ''
          ${checkSudo}
          exec "$SUDO" docker compose "$@"
        '';
      })
      (writeShellApplication {
        name = "dcup";
        text = ''
          ${checkSudo}
          "$SUDO" docker compose --project-directory "''${1:-.}" pull "''${@:2}"
          "$SUDO" docker compose --project-directory "''${1:-.}" build "''${@:2}"
          "$SUDO" docker compose --project-directory "''${1:-.}" up --detach "''${@:2}"
          "$SUDO" docker image prune --all --force
        '';
      })
      (writeShellApplication {
        name = "docker-reset";
        text = ''
          ${checkSudo}
          exec "$SUDO" docker system prune --all --force
        '';
      })
      (writeShellApplication {
        name = "flakeup";
        text = nixup;
      })
      (writeShellApplication {
        name = "nixup";
        text = nixup;
      })
      (writeShellApplication {
        name = "dev";
        text = ''
          exec ${lib.getExe pkgs.nix} develop "$@"
        '';
      })
      (writeShellApplication {
        name = "encrypt";
        text = ''
          if [ "$#" -ne 3 ]; then
            ${echo} "Usage: $0 SOURCE TARGET RECIPIENT" >&2
            exit 1
          fi

          exec ${gnupg}/bin/gpg --output "$2" --encrypt --recipient "$3" "$1"
        '';
      })
      (writeShellApplication {
        name = "decrypt";
        text = ''
          if [ "$#" -ne 2 ]; then
            ${echo} "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi

          exec ${gnupg}/bin/gpg --output "$2" --decrypt "$1"
        '';
      })
      (writeShellApplication {
        name = "backup";
        text = ''
          if [ "$#" -ne 2 ]; then
            ${echo} "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi
          ${checkSudo}
          ${coreutils}/bin/mkdir -p "$2"
          TIMESTAMP=$(${coreutils}/bin/date +"%Y-%m-%d-%H-%M-%S")
          "$SUDO" ${gnutar}/bin/tar czf "$2/$TIMESTAMP.tgz" "$1"
        '';
      })
      (writeShellApplication {
        name = "restore";
        text = ''
          if [ "$#" -ne 2 ]; then
            ${echo} "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi
          ${checkSudo}
          ${coreutils}/bin/mkdir -p "$2"
          "$SUDO" ${gnutar}/bin/tar xf "$1" -C "$2"
        '';
      })
      (writeShellApplication {
        name = "nixos-env";
        text = ''
          ${checkSudo}
          exec "$SUDO" ${nix}/bin/nix-env --profile /nix/var/nix/profiles/system "$@"
        '';
      })
    ];
  };
}
