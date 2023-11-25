{
  inputs,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  echo = "${lib.getBin pkgs.coreutils}/bin/echo";
  nixup = ''
    exec ${lib.getExe pkgs.nix} flake update \
    --commit-lock-file \
    --commit-lockfile-summary 'chore(deps): update flake.lock' \
    "$@"
  '';
  checkSudo = inputs.self.lib.checkSudo;
  nix-prefetch-sri = pkgs.writeShellApplication {
    name = "nix-prefetch-sri";
    text = ''
      exec ${lib.getExe pkgs.nix} hash to-sri --type "sha256" "$(${lib.getBin pkgs.nix}/bin/nix-prefetch-url "$@")"
    '';
  };
in {
  home = {
    shellAliases = {
      cat = lib.getExe pkgs.bat;
      l = "ll";
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
          exec ${lib.getBin imagemagick}/bin/mogrify -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
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
          exec ${lib.getBin imagemagick}/bin/mogrify -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
        '';
      })
      (writeShellApplication {
        name = "gc";
        text = ''
          ${checkSudo}
          set -x #echo on
          "$SUDO" ${lib.getBin nix}/bin/nix-collect-garbage --delete-older-than 7d
          ${lib.getBin nix}/bin/nix-collect-garbage --delete-older-than 7d
          ${lib.getExe nix} store gc
          ${lib.getExe nix} store optimise
        '';
      })
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/tasks/auto-upgrade.nix#L204
      (writeShellApplication {
        name = "needs-reboot";
        text = ''
          booted="$(${lib.getBin coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(${lib.getBin coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

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

          exec ${lib.getExe gnupg} --output "$2" --encrypt --recipient "$3" "$1"
        '';
      })
      (writeShellApplication {
        name = "decrypt";
        text = ''
          if [ "$#" -ne 2 ]; then
            ${echo} "Usage: $0 SOURCE TARGET" >&2
            exit 1
          fi

          exec ${lib.getExe gnupg} --output "$2" --decrypt "$1"
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
          ${lib.getBin coreutils}/bin/mkdir -p "$2"
          TIMESTAMP=$(${lib.getBin coreutils}/bin/date +"%Y-%m-%d-%H-%M-%S")
          "$SUDO" ${lib.getExe gnutar} czf "$2/$TIMESTAMP.tgz" "$1"
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
          ${lib.getBin coreutils}/bin/mkdir -p "$2"
          "$SUDO" ${lib.getExe gnutar} xf "$1" -C "$2"
        '';
      })
      (writeShellApplication {
        name = "nixos-env";
        text = ''
          ${checkSudo}
          exec "$SUDO" ${lib.getBin nix}/bin/nix-env --profile /nix/var/nix/profiles/system "$@"
        '';
      })
      nix-prefetch-sri
      (writeShellApplication {
        name = "nix-prefetch-sri-batch";
        text = ''
          if [ "$#" -ne 1 ]; then
            ${echo} "Usage: $0 NIX_EVAL_ATTRIBUTE" >&2
            exit 1
          fi
          exec ${lib.getExe nix} eval --raw "$1" \
           --apply "attrs: builtins.concatStringsSep \"\\n\" (builtins.attrValues (builtins.mapAttrs (name: value: value.url) attrs))" \
           | ${lib.getBin findutils}/bin/xargs -l ${lib.getExe nix-prefetch-sri}
        '';
      })
    ];
  };
}
