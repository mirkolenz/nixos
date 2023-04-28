{ lib, pkgs, config, osConfig, ... }:
let
  fishGreeting =
    if pkgs.stdenv.isLinux then ''
      if set -q SSH_TTY; and status is-login
        macchina --theme Lithium
      end
    '' else "";
in
{
  programs.fish = {
    enable = true;
    # https://github.com/direnv/direnv/issues/614#issuecomment-744575699
    loginShellInit = ''
      set -q DIRENV_DIR
      and test -n "$DIRENV_DIR"
      and eval (pushd /; direnv export fish; popd;)
    '';
    functions = {
      fish_greeting = {
        body = fishGreeting;
        description = "Override the default greeting";
      };
      # https://github.com/fish-shell/fish-shell/blob/master/share/functions/_validate_int.fish
      _validate_string = {
        noScopeShadowing = true;
        body = ''
          if not set -q _flag_value; or not test -n $_flag_value
            echo "Option $_flag_name is empty" >&2
            return 1
          end
        '';
      };
      dcup = {
        body = ''
          sudo docker compose --file "$file" pull
          sudo docker compose --file "$file" build
          sudo docker compose --file "$file" up --detach
          sudo docker image prune --all --force
        '';
        wraps = "docker compose";
        description = "Update all docker-compose containers";
        argumentNames = [ "file" ];
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
