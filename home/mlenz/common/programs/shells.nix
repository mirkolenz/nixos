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
    generateCompletions = true;
    interactiveShellInit = /* fish */ ''
      source ${pkgs.github-theme-contrib}/share/themes/fish/github_dark_default.fish

      if set -q SSH_CONNECTION
        eval (${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | string collect)
      end
    '';
    functions.fish_greeting.body = /* fish */ ''
      if set -q SSH_CONNECTION
        ${lib.getExe config.programs.macchina.package}
      end
    '';
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # todo: remove after stateVersion >= 26.05
    dotDir = "${config.xdg.configHome}/zsh";
  };
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
  # this is slow
  programs.man.generateCaches = false;
}
