{
  pkgs,
  lib,
  osConfig,
  os,
  ...
}:
let
  # The order of $PATH is wrong on standalone installations and on macOS
  # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
  dquote = str: "\"" + str + "\"";
  makeBinPathList = map (path: path + "/bin");
  profilePaths = lib.concatMapStringsSep " " dquote (makeBinPathList osConfig.environment.profiles);
  fixNixProfile =
    if osConfig == { } then
      ''
        for profile in (string split " " "$NIX_PROFILES")
          fish_add_path --prepend --move "$profile/bin"
        end
        set fish_user_paths $fish_user_paths
      ''
    else if os == "darwin" then
      ''
        fish_add_path --prepend --move --path ${profilePaths}
        set fish_user_paths $fish_user_paths
      ''
    else
      "";
in
{
  programs.fish = {
    enable = true;
    loginShellInit = ''
      ${fixNixProfile}
    '';
    functions = {
      fish_greeting = {
        body =
          if pkgs.stdenv.isLinux then
            ''
              if set -q SSH_TTY; and status is-login
                ${lib.getExe pkgs.macchina}
              end
            ''
          else
            "";
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
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };
  programs.bash = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      disable_stdin = true;
      hide_env_diff = true;
      load_dotenv = false;
      log_format = "-";
      strict_env = true;
      warn_timeout = "0s";
    };
  };
}
