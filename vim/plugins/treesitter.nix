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
    highlightCurrentScope.enable = false;
    highlightDefinitions.enable = true;
    navigation.enable = true;
    smartRename.enable = true;
  };
}
