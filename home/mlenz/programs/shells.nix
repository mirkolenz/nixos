{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  fishGreeting =
    if pkgs.stdenv.isLinux then
      ''
        if set -q SSH_TTY; and status is-login
          ${lib.getExe pkgs.macchina}
        end
      ''
    else
      "";
  # If PATH is wrong on darwin, try this:
  # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
  fixNixProfile =
    if osConfig == { } then
      ''
        for profile in (string split " " "$NIX_PROFILES")
          fish_add_path --prepend --move "$profile/bin"
        end
      ''
    else
      "";
in
{
  programs.fish = {
    enable = true;
    # https://github.com/direnv/direnv/issues/614#issuecomment-744575699
    loginShellInit = ''
      set -q DIRENV_DIR
      and test -n "$DIRENV_DIR"
      and eval (pushd /; direnv export fish; popd;)
      ${fixNixProfile}
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
        argumentNames = [
          "source"
          "target"
        ];
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };
  programs.bash = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
}
