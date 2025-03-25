{ ... }:
{
  home.shell.enableShellIntegration = true;
  programs.zellij = {
    attachExistingSession = true;
    exitShellOnExit = true;
  };
  programs.tex-fmt = {
    enable = true;
    settings = {
      wrap = false;
      tabsize = 2;
      tabchar = "space";
      lists = [
        "enumerate*"
        "itemize*"
        "description*"
      ];
    };
  };
}
