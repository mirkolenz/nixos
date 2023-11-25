{
  inputs,
  pkgs,
  lib,
  ...
}: let
  echo = "${lib.getBin pkgs.coreutils}/bin/echo";
  checkSudo = inputs.self.lib.checkSudo;
  cmdTexts = {
    pull-rebuild = ''
      set -x #echo on
      FLAKE=''${1:-"github:mirkolenz/nixos"}

      if [[ "$FLAKE" != github* ]]; then
        ${lib.getExe pkgs.git} -C "$FLAKE" pull
      fi

      exec ${lib.getExe pkgs.nix} run "$FLAKE" -- "''${@:2}"
    '';
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-convert = ''
      if [ "$#" -ne 3 ]; then
        ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY" >&2
        exit 1
      fi
      exec ${lib.getBin pkgs.imagemagick}/bin/mogrify -path "$2" -strip -interlace none -sampling-factor 4:2:0 -define jpeg:dct-method=float -quality "$3" "$1"
    '';
    # https://masdilor.github.io/use-imagemagick-to-resize-and-compress-images/
    mogrify-resize = ''
      if [ "$#" -ne 4 ]; then
        ${echo} "Usage: $0 INPUT_FILE OUTPUT_FOLDER QUALITY FINAL_SIZE" >&2
        exit 1
      fi
      exec ${lib.getBin pkgs.imagemagick}/bin/mogrify -path "$2" -filter Triangle -define filter:support=2 -thumbnail "$4" -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality "$3" -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "$1"
    '';
    gc = ''
      ${checkSudo}
      set -x #echo on
      "$SUDO" ${lib.getBin pkgs.nix}/bin/nix-collect-garbage --delete-older-than 7d
      ${lib.getBin pkgs.nix}/bin/nix-collect-garbage --delete-older-than 7d
      ${lib.getExe pkgs.nix} store gc
      ${lib.getExe pkgs.nix} store optimise
    '';
    # https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/tasks/auto-upgrade.nix#L204
    needs-reboot = ''
      booted="$(${lib.getBin pkgs.coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
      built="$(${lib.getBin pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

      if [ "$booted" != "$built" ]; then
        ${echo} "REBOOT NEEDED"
        exit 1
      fi

      exit 0
    '';
    dc = ''
      ${checkSudo}
      exec "$SUDO" docker compose "$@"
    '';
    dcup = ''
      ${checkSudo}
      "$SUDO" docker compose --project-directory "''${1:-.}" pull "''${@:2}"
      "$SUDO" docker compose --project-directory "''${1:-.}" build "''${@:2}"
      "$SUDO" docker compose --project-directory "''${1:-.}" up --detach "''${@:2}"
      "$SUDO" docker image prune --all --force
    '';
    docker-reset = ''
      ${checkSudo}
      exec "$SUDO" docker system prune --all --force
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
        ${echo} "Usage: $0 SOURCE TARGET" >&2
        exit 1
      fi
      ${checkSudo}
      ${lib.getBin pkgs.coreutils}/bin/mkdir -p "$2"
      TIMESTAMP=$(${lib.getBin pkgs.coreutils}/bin/date +"%Y-%m-%d-%H-%M-%S")
      "$SUDO" ${lib.getExe pkgs.gnutar} czf "$2/$TIMESTAMP.tgz" "$1"
    '';
    restore = ''
      if [ "$#" -ne 2 ]; then
        ${echo} "Usage: $0 SOURCE TARGET" >&2
        exit 1
      fi
      ${checkSudo}
      ${lib.getBin pkgs.coreutils}/bin/mkdir -p "$2"
      "$SUDO" ${lib.getExe pkgs.gnutar} xf "$1" -C "$2"
    '';
    nixos-env = ''
      ${checkSudo}
      exec "$SUDO" ${lib.getBin pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system "$@"
    '';
    nix-prefetch-sri = ''
      exec ${lib.getExe pkgs.nix} hash to-sri --type "sha256" "$(${lib.getBin pkgs.nix}/bin/nix-prefetch-url "$@")"
    '';
    nix-prefetch-sri-batch = ''
      if [ "$#" -ne 1 ]; then
        ${echo} "Usage: $0 NIX_EVAL_ATTRIBUTE" >&2
        exit 1
      fi
      exec ${lib.getExe pkgs.nix} eval --raw "$1" \
       --apply "attrs: builtins.concatStringsSep \"\\n\" (builtins.attrValues (builtins.mapAttrs (name: value: value.url) attrs))" \
       | ${lib.getBin pkgs.findutils}/bin/xargs -l ${lib.getExe cmds.nix-prefetch-sri}
    '';
  };
  cmds = lib.mapAttrs (name: text: pkgs.writeShellApplication {inherit name text;}) cmdTexts;
in {
  home.packages = builtins.attrValues cmds;
}
