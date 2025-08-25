{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = lib.mapAttrsToList (name: text: pkgs.writeShellApplication { inherit name text; }) {
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-convert = ''
      if [ "$#" -ne 3 ]; then
        echo "Usage: $0 INPUT_FILE OUTPUT_DIR QUALITY" >&2
        exit 1
      fi
      exec ${lib.getExe' pkgs.imagemagick "mogrify"} -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
    '';
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-resize = ''
      if [ "$#" -ne 4 ]; then
        echo "Usage: $0 INPUT_FILE OUTPUT_DIR QUALITY FINAL_SIZE" >&2
        exit 1
      fi
      exec ${lib.getExe' pkgs.imagemagick "mogrify"} -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
    '';
    gc = ''
      set -x #echo on
      sudo nix-collect-garbage --delete-older-than 7d
      nix-collect-garbage --delete-older-than 7d
      nix store optimise
    '';
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/tasks/auto-upgrade.nix#L243
    needs-reboot = ''
      booted="$(${lib.getExe' pkgs.coreutils "readlink"} /run/booted-system/{initrd,kernel,kernel-modules})"
      built="$(${lib.getExe' pkgs.coreutils "readlink"} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

      if [ "$booted" != "$built" ]; then
        echo "REBOOT NEEDED"
        exit 1
      fi

      exit 0
    '';
    docker-reset = ''
      exec sudo docker system prune --all --force
    '';
    flakeup = ''
      exec nix flake update --commit-lock-file "$@"
    '';
    uvup = ''
      ${lib.getExe config.programs.uv.package} sync --all-extras --upgrade
      ${lib.getExe config.programs.git.package} commit -m "chore(deps): update uv.lock" uv.lock
    '';
    npmup = ''
      ${lib.getExe pkgs.npm-check-updates} --interactive --format group --install never
      ${lib.getExe config.programs.git.package} commit -m "chore(deps): update package.json" package.json
      ${lib.getExe' pkgs.nodejs "npm"} update
      ${lib.getExe config.programs.git.package} commit -m "chore(deps): update package-lock.json" package-lock.json
    '';
    dev = ''
      exec nix develop "$@"
    '';
    encrypt = ''
      if [ "$#" -ne 3 ]; then
        echo "Usage: $0 SOURCE TARGET RECIPIENT" >&2
        exit 1
      fi

      exec ${lib.getExe pkgs.gnupg} --output "$2" --encrypt --recipient "$3" "$1"
    '';
    decrypt = ''
      if [ "$#" -ne 2 ]; then
        echo "Usage: $0 SOURCE TARGET" >&2
        exit 1
      fi

      exec ${lib.getExe pkgs.gnupg} --output "$2" --decrypt "$1"
    '';
    backup = ''
      if [ "$#" -ne 2 ]; then
        echo "Usage: $0 SOURCE_PATH TARGET_DIR" >&2
        exit 1
      fi
      ${lib.getExe' pkgs.coreutils "mkdir"} -p "$2"
      TIMESTAMP=$(${lib.getExe' pkgs.coreutils "date"} +"%Y-%m-%d-%H-%M-%S")
      sudo ${lib.getExe pkgs.gnutar} -czf "$2/$TIMESTAMP.tgz" "$1"
    '';
    restore = ''
      if [ "$#" -ne 2 ]; then
        echo "Usage: $0 SOURCE_PATH TARGET_DIR" >&2
        exit 1
      fi
      ${lib.getExe' pkgs.coreutils "mkdir"} -p "$2"
      sudo ${lib.getExe pkgs.gnutar} -xzf "$1" -C "$2"
    '';
    compress = ''
      if [ "$#" -lt 1 ]; then
        echo "Usage: $0 SOURCE_PATH [TAR_ARGS...]" >&2
        exit 1
      fi
      source_path="$1"
      shift

      exec ${lib.getExe pkgs.gnutar} -czf "$source_path.tgz" "$source_path" "$@"
    '';
    decompress = ''
      if [ "$#" -lt 1 ]; then
        echo "Usage: $0 SOURCE_PATH [TAR_ARGS...]" >&2
        exit 1
      fi
      source_path="$1"
      shift

      exec ${lib.getExe pkgs.gnutar} -xzf "$source_path" "$@"
    '';
    # https://github.com/typst/typst/discussions/404#discussioncomment-9456308
    # https://stackoverflow.com/a/61677298
    pdfcompress = ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: $0 SOURCE_PATH TARGET_PATH [GHOSTSCRIPT_ARGS...]" >&2
        exit 1
      fi

      source_path="$1"
      shift
      target_path="$1"
      shift

      exec ${lib.getExe pkgs.ghostscript} \
        -dNOPAUSE -dQUIET -dBATCH -dSAFER \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS=/ebook \
        -dAutoRotatePages=/None \
        -dCompatibilityLevel=1.7 \
        -dCompressFonts=true \
        -dConvertCMYKImagesToRGB=true \
        -dDetectDuplicateImages \
        -dEmbedAllFonts=true \
        -dOverPrint=/simulate \
        -dSubsetFonts=true \
        -dColorImageDownsampleType=/Bicubic \
        -dColorImageResolution=150 \
        -dGrayImageDownsampleType=/Bicubic \
        -dGrayImageResolution=150 \
        -dMonoImageDownsampleType=/Bicubic \
        -dMonoImageResolution=150 \
        "$@" \
        -sOutputFile="$target_path" \
        -f "$source_path"
    '';
    # https://polylux.dev/book/external/pdfpc.html
    # https://touying-typ.github.io/docs/external/pdfpc
    touying2pdfpc = ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: $0 FILENAME [TYPST_ARGS...]" >&2
        exit 1
      fi

      filename="$1"
      shift

      ${lib.getExe pkgs.typst} query \
        --root . \
        "./$filename.typ" \
        --field value \
        --one "<pdfpc-file>" \
        > "./$filename.pdfpc"
    '';
    nixos-env = ''
      exec sudo nix-env --profile /nix/var/nix/profiles/system "$@"
    '';
    prefetch-attr = ''
      if [ "$#" -lt 1 ]; then
        echo "Usage: $0 NIX_FLAKE_ATTR [NIX_PREFETCH_ARGS...]" >&2
        exit 1
      fi
      value="$(nix eval --raw "$1")"
      shift
      hash="$(nix store prefetch-file --json "$@" "$value" | ${lib.getExe pkgs.jq} -r .hash)"
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
      nix eval --json "$attrs" \
        | ${lib.getExe pkgs.jq} -r 'to_entries[] | "\(.key) \(.value)"' \
        | while read -r key value; do
          echo "Evaluating $key" >&2
          hash="$(nix store prefetch-file --json "$@" "$value" | ${lib.getExe pkgs.jq} -r .hash)"
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
}
