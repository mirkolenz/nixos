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
    interactiveShellInit = lib.optionalString config.custom.profile.isServer ''
      # zellij setup --generate-auto-start fish
      if not set -q ZELLIJ; and set -q SSH_CONNECTION
        zellij attach --create "ssh"
      end
    '';
    functions.fish_greeting.body = ''
      if set -q ZELLIJ; and set -q SSH_CONNECTION
        ${lib.getExe config.programs.macchina.package}
      end
    '';
  };
  xdg.configFile = {
    "fish/themes/flexoki-dark.theme".source = "${pkgs.flexoki}/share/fish/flexoki-dark.theme";
    "fish/themes/flexoki-light.theme".source = "${pkgs.flexoki}/share/fish/flexoki-light.theme";
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
