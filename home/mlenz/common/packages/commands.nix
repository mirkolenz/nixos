{
  pkgs,
  lib,
  config,
  ...
}:
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
      sudo ${lib.getExe' config.nix.package "nix-collect-garbage"} --delete-older-than 7d
      ${lib.getExe' config.nix.package "nix-collect-garbage"} --delete-older-than 7d
      ${lib.getExe config.nix.package} store optimise
    '';
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/tasks/auto-upgrade.nix#L243
    needs-reboot = ''
      booted="$(${lib.getExe' pkgs.coreutils "readlink"} /run/booted-system/{initrd,kernel,kernel-modules})"
      built="$(${lib.getExe' pkgs.coreutils "readlink"} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

      if [ "$booted" != "$built" ]; then
        ${echo} "REBOOT NEEDED"
        exit 1
      fi

      exit 0
    '';
    docker-reset = ''
      exec sudo docker system prune --all --force
    '';
    flakeup = ''
      exec ${lib.getExe config.nix.package} flake update \
      --commit-lock-file \
      --commit-lockfile-summary "chore(deps): update flake.lock" \
      "$@"
    '';
    uvup = ''
      ${lib.getExe config.programs.uv.package} sync --all-extras --upgrade
      ${lib.getExe config.programs.git.package} add uv.lock
      ${lib.getExe config.programs.git.package} commit -m "chore(deps): update uv.lock"
    '';
    npmup = ''
      ${lib.getExe pkgs.npm-check-updates} --interactive --format group --install never
      ${lib.getExe' pkgs.nodejs "npm"} update
      ${lib.getExe config.programs.git.package} add package.json package-lock.json
      ${lib.getExe config.programs.git.package} commit -m "chore(deps): update package.json and package-lock.json"
    '';
    dev = ''
      exec ${lib.getExe config.nix.package} develop "$@"
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
      exec sudo ${lib.getExe' config.nix.package "nix-env"} --profile /nix/var/nix/profiles/system "$@"
    '';
    prefetch-attr = ''
      if [ "$#" -lt 1 ]; then
        ${echo} "Usage: $0 NIX_FLAKE_ATTR [NIX_PREFETCH_ARGS...]" >&2
        exit 1
      fi
      value="$(${lib.getExe config.nix.package} eval --raw "$1")"
      shift
      hash="$(${lib.getExe config.nix.package} store prefetch-file --json "$@" "$value" | ${lib.getExe pkgs.jq} -r .hash)"
      echo "hash = \"$hash\";"
    '';
    prefetch-attrs = ''
      if [ "$#" -lt 1 ]; then
        echo "Usage: $0 NIX_FLAKE_ATTRS [NIX_PREFETCH_ARGS...]" >&2
        exit 1
      fi
      TMPFILE="$(mktemp)"
      attrs="$1"
      shift
      echo "hashes = {" >> "$TMPFILE"
      ${lib.getExe config.nix.package} eval --json "$attrs" \
        | ${lib.getExe pkgs.jq} -r 'to_entries[] | "\(.key) \(.value)"' \
        | while read -r key value; do
          echo "Evaluating $key" >&2
          hash="$(${lib.getExe config.nix.package} store prefetch-file --json "$@" "$value" | ${lib.getExe pkgs.jq} -r .hash)"
          echo "  $key = \"$hash\";" >> "$TMPFILE"
        done
      echo "};" >> "$TMPFILE"
      cat "$TMPFILE"
      rm "$TMPFILE"
    '';
    nixbuild-shell = ''
      exec rlwrap ssh eu.nixbuild.net shell
    '';
    noeol = ''
      exec ${lib.getExe' pkgs.coreutils "tr"} -d '\n'
    '';
    json-tool = ''
      exec ${lib.getExe pkgs.python3} -m json.tool "$@"
    '';
    fontconvert = ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: $0 SOURCE TARGET [FONTFORGE_ARGS...]" >&2
        exit 1
      fi
      source="$1"
      shift
      target="$1"
      shift
      exec ${lib.getExe' pkgs.fontforge "fontforge"} -c "Open(\"$source\"); Generate(\"$target\");" "$@"
    '';
  };
  cmds = lib.mapAttrs (name: text: pkgs.writeShellApplication { inherit name text; }) cmdTexts;
in
{
  home.packages = lib.attrValues cmds;
}
