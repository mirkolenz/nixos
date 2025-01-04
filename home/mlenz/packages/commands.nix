{ pkgs, lib, ... }:
let
  echo = lib.getExe' pkgs.coreutils "echo";
  cmdTexts = {
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-convert = ''
      if [ "$#" -ne 3 ]; then
        ${echo} "Usage: $0 INPUT_FILE OUTPUT_DIR QUALITY" >&2
        exit 1
      fi
      exec ${lib.getExe' pkgs.imagemagick "mogrify"} -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
    '';
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-resize = ''
      if [ "$#" -ne 4 ]; then
        ${echo} "Usage: $0 INPUT_FILE OUTPUT_DIR QUALITY FINAL_SIZE" >&2
        exit 1
      fi
      exec ${lib.getExe' pkgs.imagemagick "mogrify"} -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
    '';
    gc = ''
      set -x #echo on
      sudo ${lib.getExe' pkgs.nix "nix-collect-garbage"} --delete-older-than 7d
      ${lib.getExe' pkgs.nix "nix-collect-garbage"} --delete-older-than 7d
      ${lib.getExe pkgs.nix} store optimise
    '';
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/tasks/auto-upgrade.nix#L214
    needs-reboot = ''
      booted="$(${lib.getExe' pkgs.coreutils "readlink"} /run/booted-system/{initrd,kernel,kernel-modules})"
      built="$(${lib.getExe' pkgs.coreutils "readlink"} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

      if [ "$booted" != "$built" ]; then
        ${echo} "REBOOT NEEDED"
        exit 1
      fi

      exit 0
    '';
    dc = ''
      exec sudo docker compose "$@"
    '';
    dcup = ''
      sudo docker compose --project-directory "''${1:-.}" pull "''${@:2}"
      sudo docker compose --project-directory "''${1:-.}" build "''${@:2}"
      sudo docker compose --project-directory "''${1:-.}" up --detach "''${@:2}"
      sudo docker image prune --all --force
    '';
    docker-reset = ''
      exec sudo docker system prune --all --force
    '';
    flakeup = ''
      exec ${lib.getExe pkgs.nix} flake update \
      --commit-lock-file \
      --commit-lockfile-summary 'chore(deps): update flake.lock' \
      "$@"
    '';
    dev = ''
      exec ${lib.getExe pkgs.nix} develop "$@"
    '';
    encrypt = ''
      if [ "$#" -ne 3 ]; then
        ${echo} "Usage: $0 SOURCE TARGET RECIPIENT" >&2
        exit 1
      fi

      exec ${lib.getExe pkgs.gnupg} --output "$2" --encrypt --recipient "$3" "$1"
    '';
    decrypt = ''
      if [ "$#" -ne 2 ]; then
        ${echo} "Usage: $0 SOURCE TARGET" >&2
        exit 1
      fi

      exec ${lib.getExe pkgs.gnupg} --output "$2" --decrypt "$1"
    '';
    backup = ''
      if [ "$#" -ne 2 ]; then
        ${echo} "Usage: $0 SOURCE_PATH TARGET_DIR" >&2
        exit 1
      fi
      ${lib.getExe' pkgs.coreutils "mkdir"} -p "$2"
      TIMESTAMP=$(${lib.getExe' pkgs.coreutils "date"} +"%Y-%m-%d-%H-%M-%S")
      sudo ${lib.getExe pkgs.gnutar} czf "$2/$TIMESTAMP.tgz" "$1"
    '';
    restore = ''
      if [ "$#" -ne 2 ]; then
        ${echo} "Usage: $0 SOURCE_PATH TARGET_DIR" >&2
        exit 1
      fi
      ${lib.getExe' pkgs.coreutils "mkdir"} -p "$2"
      sudo ${lib.getExe pkgs.gnutar} xf "$1" -C "$2"
    '';
    nixos-env = ''
      exec sudo ${lib.getExe' pkgs.nix "nix-env"} --profile /nix/var/nix/profiles/system "$@"
    '';
    prefetch-attr = ''
      if [ "$#" -lt 1 ]; then
        ${echo} "Usage: $0 NIX_FLAKE_ATTR [NIX_PREFETCH_ARGS...]" >&2
        exit 1
      fi
      value="$(${lib.getExe pkgs.nix} eval --raw "$1")"
      ${lib.getExe pkgs.nix} store prefetch-file --json "''${@:2}" "$value" | ${lib.getExe pkgs.jq} -r .hash
    '';
    prefetch-attrs = ''
      if [ "$#" -lt 1 ]; then
        echo "Usage: $0 NIX_FLAKE_ATTR [NIX_PREFETCH_ARGS...]" >&2
        exit 1
      fi
      TMPFILE="$(mktemp)"
      echo "{" >> "$TMPFILE"
      ${lib.getExe pkgs.nix} eval --json "$1" \
        | ${lib.getExe pkgs.jq} -r 'to_entries[] | "\(.key) \(.value)"' \
        | while read -r key value; do
          echo "Evaluating $key" >&2
          hash="$(${lib.getExe pkgs.nix} store prefetch-file --json "''${@:2}" "$value" | ${lib.getExe pkgs.jq} -r .hash)"
          echo "  $key = \"$hash\";" >> "$TMPFILE"
        done
      echo "}" >> "$TMPFILE"
      cat "$TMPFILE"
      rm "$TMPFILE"
    '';
    nixbuild-shell = ''
      exec rlwrap ssh eu.nixbuild.net shell
    '';
    noeol = ''
      exec ${lib.getExe' pkgs.coreutils "tr"} -d '\n'
    '';
  };
  cmds = lib.mapAttrs (name: text: pkgs.writeShellApplication { inherit name text; }) cmdTexts;
in
{
  home.packages = builtins.attrValues cmds;
}
