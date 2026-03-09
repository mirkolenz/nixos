{ ... }:
{
  colorscheme = "flexoki-dark";
  colorschemes = {
    flexoki.enable = true;
    github-theme = {
      enable = false;
      settings.options = {
        transparent = false;
        terminal_colors = true;
      };
    };
    monokai-pro = {
      enable = false;
      settings = {
        filter = "spectrum";
      };
    };
    catppuccin = {
      enable = false;
      settings = {
        background = {
          light = "latte";
          dark = "mocha";
        };
      };
    };
  };
}
