{
  pkgs,
  lib,
  ...
}: let
  fishGreeting =
    if pkgs.stdenv.isLinux
    then ''
      if set -q SSH_TTY; and status is-login
        ${lib.getExe pkgs.macchina} --theme Lithium
      end
    ''
    else "";
in {
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
        argumentNames = ["source" "target"];
      };
    };
  };
}
