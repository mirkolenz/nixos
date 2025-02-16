{ ... }:
{
  plugins.treesitter = {
    enable = true;
    folding = true;
    settings = {
      highlight.enable = true;
      incremental_selection.enable = true;
      indent.enable = true;
    };
  };
  plugins.treesitter-refactor = {
    enable = true;
    highlightCurrentScope.enable = true;
    highlightDefinitions.enable = true;
    smartRename.enable = true;
  };
}
