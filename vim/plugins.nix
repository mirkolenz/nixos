{ ... }:
{
  plugins = {
    comment = {
      enable = true;
    };
    treesitter = {
      enable = true;
      folding = true;
      settings.indent.enable = true;
    };
    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = true;
      highlightDefinitions.enable = true;
      smartRename.enable = true;
    };
    telescope = {
      enable = true;
      extensions.file-browser.enable = true;
    };
    todo-comments = {
      enable = true;
    };
    trouble = {
      enable = true;
    };
    fugitive = {
      enable = true;
    };
    gitgutter = {
      enable = true;
    };
    copilot-vim = {
      enable = true;
    };
    oil = {
      enable = false;
    };
    web-devicons = {
      enable = true;
    };
  };
}
