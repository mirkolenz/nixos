{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.shell.enableShellIntegration = true;
  programs.fish = {
    enable = true;
    # depends on programs.man.generateCaches
    generateCompletions = false;
    loginShellInit = ''
      fish_add_path "${config.home.homeDirectory}/bin"
    '';
    interactiveShellInit = ''
      source ${pkgs.github-theme-contrib}/share/themes/fish/github_dark_default.fish
    '';
    functions = {
      fish_greeting = {
        body =
          if pkgs.stdenv.isLinux then
            ''
              if set -q SSH_TTY; and status is-login
                ${lib.getExe config.programs.macchina.package}
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
    enableCompletion = true;
  };
  # this is slow
  programs.man.generateCaches = false;
}
