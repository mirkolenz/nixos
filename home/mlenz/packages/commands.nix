{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  exaArgs = "--long --icons --group-directories-first --git --color=always --time-style=long-iso";
  echo = "${pkgs.coreutils}/bin/echo";
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
      (writeShellScriptBin "dc" ''
        exec docker compose "$@"
      '')
      (writeShellScriptBin "docker-reset" ''
        exec docker system prune --all --force
      '')
      (writeShellScriptBin "pull-rebuild" ''
        set -x #echo on
        FLAKE=''${1:-"github:mirkolenz/nixos"}

        if [[ "$FLAKE" != github* ]]; then
          ${lib.getExe git} -C "$FLAKE" pull
        fi

        exec ${lib.getExe nix} run "$FLAKE" -- "''${@:2}"
      '')
      # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
      (writeShellScriptBin "mogrify-convert" ''
        if [ "$#" -ne 3 ]; then
          ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY" >&2
          exit 1
        fi
        exec ${imagemagick}/bin/mogrify -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
      '')
      # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
      (writeShellScriptBin "mogrify-resize" ''
        if [ "$#" -ne 4 ]; then
          ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY FINAL_SIZE" >&2
          exit 1
        fi
        exec ${imagemagick}/bin/mogrify -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
      '')
      (writeShellScriptBin "gc" ''
        if [ "$(id -u)" -ne 0 ]; then
          ${echo} "To clean the system store, also run as root"
        fi
        set -x #echo on
        ${lib.getExe nix} store optimise
        ${lib.getExe nix} store gc
        ${nix}/bin/nix-collect-garbage --delete-older-than 7d
      '')
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/tasks/auto-upgrade.nix#L204
      (writeShellScriptBin "needs-reboot" ''
        booted="$(${coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
        built="$(${coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

        if [ "$booted" != "$built" ]; then
          ${echo} "REBOOT NEEDED"
          exit 1
        fi

        exit 0
      '')
      (writeShellScriptBin "dcup" ''
        if [ "$#" -ne 1 ]; then
          ${echo} "Usage: $0 FILE" >&2
          exit 1
        fi
        ${checkSudo}
        "$SUDO" docker compose --file "$1" pull
        "$SUDO" docker compose --file "$1" build
        "$SUDO" docker compose --file "$1" up --detach
        "$SUDO" docker image prune --all --force
      '')
      (writeShellScriptBin "encrypt" ''
        if [ "$#" -ne 3 ]; then
          ${echo} "Usage: $0 SOURCE TARGET RECIPIENT" >&2
          exit 1
        fi

        exec ${gnupg}/bin/gpg --output "$2" --encrypt --recipient "$3" "$1"
      '')
      (writeShellScriptBin "decrypt" ''
        if [ "$#" -ne 2 ]; then
          ${echo} "Usage: $0 SOURCE TARGET" >&2
          exit 1
        fi

        exec ${gnupg}/bin/gpg --output "$2" --decrypt "$1"
      '')
      (writeShellScriptBin "backup" ''
        if [ "$#" -ne 2 ]; then
          ${echo} "Usage: $0 SOURCE TARGET" >&2
          exit 1
        fi
        ${checkSudo}
        ${coreutils}/bin/mkdir -p "$2"
        TIMESTAMP=$(${coreutils}/bin/date +"%Y-%m-%d-%H-%M-%S")
        "$SUDO" ${gnutar}/bin/tar czf "$2/$TIMESTAMP.tgz" "$1"
      '')
      (writeShellScriptBin "restore" ''
        if [ "$#" -ne 2 ]; then
          ${echo} "Usage: $0 SOURCE TARGET" >&2
          exit 1
        fi
        ${checkSudo}
        ${coreutils}/bin/mkdir -p "$2"
        "$SUDO" ${gnutar}/bin/tar xf "$1" -C "$2"
      '')
    ];
  };
}
