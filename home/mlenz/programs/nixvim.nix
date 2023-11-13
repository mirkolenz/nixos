{
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    options = {
      # syntax = "on";
      autoindent = true;
      clipboard = "unnamed";
      expandtab = true;
      ignorecase = true;
      mouse = "a";
      number = true;
      ruler = true;
      shiftwidth = 2;
      smartcase = true;
      tabstop = 2;
      foldenable = false;
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          ruff-lsp.enable = true;
          pyright.enable = true;
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        indent = true;
      };
      treesitter-refactor = {
        enable = true;
        highlightCurrentScope.enable = true;
        highlightDefinitions.enable = true;
        smartRename.enable = true;
      };
    };
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
    };
  };
}
