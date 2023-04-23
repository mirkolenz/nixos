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
      fish_greeting = {
        body = ''
          if set -q SSH_TTY; and status is-login
            macchina --theme Lithium
          end
        '';
        description = "Override the default greeting";
      };
      # https://github.com/fish-shell/fish-shell/blob/master/share/functions/_validate_int.fish
      _validate_string = {
        noScopeShadowing = true;
        body = ''
          if not set -q $_flag_value; or not test -n $_flag_value
            echo "Option $_flag_name is empty" >&2
            return 1
          end
        '';
      };
      dockerup = {
        body = ''
          sudo docker compose pull $argv
          sudo docker compose build $argv
          sudo docker compose up --detach
          sudo docker image prune --all --force
        '';
        description = "Update all docker-compose containers";
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
          if test (count $argv) -ne 2
            echo "Usage: encrypt <source> <target>" >&2
            return 1
          end

          gpg --output "$target" --encrypt --recipient "$recipient" "$source"
        '';
        argumentNames = [ "source" "target" "recipient" ];
      };
      decrypt = {
        description = "Decrypt a file using gpg";
        body = ''
          if test (count $argv) -ne 2
            echo "Usage: decrypt <source> <target>" >&2
            return 1
          end

          gpg --output "$target" --decrypt "$source"
        '';
        argumentNames = [ "source" "target" ];
      };
      backup = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          set -l option_keys 'source=' 'target='
          argparse --max-args=0 $option_keys -- $argv
          or return

          set -l option_values $_flag_source $_flag_target

          if test (count $option_keys) -ne (count $option_values)
            echo "Usage: backup -i/--source <dir> -o/--target <dir>" >&2
            return 1
          end

          mkdir -p "$_flag_target"
          sudo tar czf "$_flag_target/$(date +"%Y-%m-%d-%H-%M-%S").tgz" "$_flag_source"
        '';
      };
      restore = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          if test (count $argv) -ne 2
            echo "Usage: restore <source> <target>" >&2
            return 1
          end

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
          if test (count $argv) -ne 2
            echo "Usage: otf2ttf <source> <target>" >&2
            return 1
          end

          fontforge -c 'Open("$source"); Generate("$target")'
        '';
        description = "Convert an OpenType font to TrueType";
        wraps = "fontforge";
        argumentNames = [ "source" "target" ];
      };
    };
  };
}
