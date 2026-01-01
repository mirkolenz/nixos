{ ... }:
{
  plugins.treesitter = {
    enable = true;
    folding.enable = true;
    settings = {
      highlight.enable = true;
      incremental_selection.enable = true;
      indent.enable = true;
    };
  };
  plugins.treesitter-refactor = {
    enable = false; # todo: broken as of 2026-01-01
    settings = {
      highlight_current_scope.enable = false;
      highlight_definitions.enable = true;
      navigation.enable = true;
      smart_rename.enable = true;
    };
  };
  plugins.treesitter-textobjects = {
    enable = false; # todo: broken as of 2026-01-01
    settings = {
      lsp_interop.enable = true;
      move.enable = true;
      select.enable = true;
      swap.enable = true;
    };
  };
  plugins.treesitter-context = {
    enable = true;
  };
}
