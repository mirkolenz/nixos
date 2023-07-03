{pkgs, ...}: {
  programs.nixneovim = {
    enable = true;
    defaultEditor = true;
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
    # The values are plain lua values, so double quotes are needed
    mappings = {
      # Use 'jk' to exit insert mode
      insert."jk" = ''"<esc>"'';
      # Use 'shift+return' to prepend new line
      normal."<S-Enter>" = ''"O<Esc>"'';
      # Use 'return' to append new line
      normal."<CR>" = ''"o<Esc>"'';
      # Do not yank deleted content
      visual."d" = ''"\"_d"'';
      normal."d" = ''"\"_d"'';
      terminal."<Esc>" = ''"<C-\\><C-n>"'';
    };
    plugins = {
      lsp = {
        enable = true;
        servers = {
          nil.enable = true;
          pyright.enable = true;
        };
      };
      treesitter = {
        enable = true;
        folding = true;
        indent = true;
        refactor = {
          highlightCurrentScope.enable = true;
          highlightDefinitions.enable = true;
          smartRename.enable = true;
        };
      };
    };
    colorscheme = "github_dark_high_contrast";
    extraPlugins = [pkgs.vimExtraPlugins.github-nvim-theme];
  };
}
