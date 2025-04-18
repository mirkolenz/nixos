{ ... }:
{
  colorscheme = "github_dark_default";
  colorschemes = {
    github-theme = {
      enable = true;
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
