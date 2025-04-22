{ ... }:
{
  imports = [ ./uv.nix ];
  home.shell.enableShellIntegration = true;
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
