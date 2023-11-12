{pkgs, ...}: {
  programs.nixvim = {
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
    keymaps = [
      {
        # Use 'jk' to exit insert mode
        key = "jk";
        mode = "i";
        action = ''<esc>'';
      }
      {
        # Use 'shift+return' to prepend new line
        key = "<S-Enter>";
        mode = "n";
        action = ''O<Esc>'';
      }
      {
        # Use 'return' to append new line
        key = "<CR>";
        mode = "n";
        action = ''o<Esc>'';
      }
      {
        # Do not yank deleted content (normal mode)
        key = "d";
        mode = "n";
        action = ''"_d'';
      }
      {
        # Do not yank deleted content (visual mode)
        key = "d";
        mode = "v";
        action = ''"_d'';
      }
      {
        key = "<Esc>";
        mode = "t";
        action = ''<C-\><C-n>'';
      }
    ];
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
