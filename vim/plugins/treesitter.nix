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
    settings = {
      highlight_current_scope.enable = false;
      highlight_definitions.enable = true;
      navigation.enable = true;
      smart_rename.enable = true;
    };
  };
  plugins.treesitter-textobjects = {
    enable = true;
    lspInterop.enable = true;
    move.enable = true;
    select.enable = true;
    swap.enable = true;
  };
  plugins.treesitter-context = {
    enable = true;
  };
}
