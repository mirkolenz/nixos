{ ... }:
{
  plugins.treesitter = {
    enable = true;
    folding.enable = true;
    highlight.enable = true;
    indent.enable = true;
  };
  # todo: replace with https://github.com/nvim-treesitter/nvim-treesitter-locals
  plugins.treesitter-refactor = {
    enable = false;
    settings = {
      highlight_current_scope.enable = false;
      highlight_definitions.enable = true;
      navigation.enable = true;
      smart_rename.enable = true;
    };
  };
  plugins.treesitter-textobjects = {
    enable = true;
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
