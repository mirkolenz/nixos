{ lib, pkgs, config, ... }:
{
  programs.fish = {
    enable = true;
    # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1266049484
    loginShellInit = lib.concatStringsSep "\n" [
      (lib.optionalString (pkgs.stdenv.isDarwin) ''
        for p in (string split " " $NIX_PROFILES)
          fish_add_path --prepend --move $p/bin
        end
      '')
      (lib.optionalString (config.programs.tmux.enable) ''
        if not set -q TMUX
          tmux attach-session
        end
      '')
    ];
    functions = {
      dockerup = {
        body = ''
          sudo docker compose pull $argv
          sudo docker compose build $argv
          sudo docker compose up --detach
          sudo docker image prune --all --force
        '';
        description = "Update all docker-compose containers";
      };
      fish_greeting = {
        body = ''
          if set -q SSH_TTY; and status is-login
            macchina --theme Lithium
          end
        '';
        description = "Override the default greeting";
      };
      docker-reset = {
        body = ''
          sudo docker system prune --all --force
        '';
        description = "Reset docker";
      };
      encrypt = {
        description = "Encrypt a file using gpg";
        body = ''
          gpg --output "$target" --encrypt --recipient "$recipient" "$source"
        '';
        argumentNames = [ "source" "target" "recipient" ];
      };
      decrypt = {
        description = "Decrypt a file using gpg";
        body = ''
          gpg --output "$target" --decrypt "$source"
        '';
        argumentNames = [ "source" "target" ];
      };
      backup = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          mkdir -p "$target"
          sudo tar czf "$target/$(date +"%Y-%m-%d-%H-%M-%S").tgz" "$source"
        '';
        argumentNames = [ "source" "target" ];
      };
      restore = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          mkdir -p "$target"
          sudo tar xf "$source" -C "$target"
        '';
        argumentNames = [ "source" "target" ];
      };
      divider = {
        body = ''
          set length (tput cols)
          set char =
          tput bold

          echo
          printf "%*s\n" $length "" | tr " " $char
          echo

          tput sgr0
        '';
        description = "Print a bold horizontal line";
      };
      otf2ttf = {
        body = ''
          fontforge -c 'Open("$source"); Generate("$target")'
        '';
        description = "Convert an OpenType font to TrueType";
        wraps = "fontforge";
        argumentNames = [ "source" "target" ];
      };
    };
  };
}
