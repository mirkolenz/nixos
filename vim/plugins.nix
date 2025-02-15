{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
        incremental_selection.enable = true;
        indent.enable = true;
      };
    };
    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = true;
      highlightDefinitions.enable = true;
      smartRename.enable = true;
    };
    telescope = {
      enable = true;
      extensions = {
        file-browser = {
          enable = true;
          settings = {
            hijack_netrw = true;
          };
        };
        frecency.enable = true;
        fzf-native.enable = true;
        live-grep-args.enable = true;
        media-files.enable = true;
        project.enable = true;
      };
    };
    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "luasnip"; }
        ];
      };
    };
    comment = {
      enable = true;
    };
    todo-comments = {
      enable = true;
    };
    trouble = {
      enable = true;
    };
    multicursors = {
      enable = true;
    };
    neogit = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
    gitgutter = {
      enable = true;
    };
    gitsigns = {
      enable = true;
    };
    gitignore = {
      enable = true;
    };
    copilot-lua = {
      enable = true;
      settings = {
        filetypes = {
          "*" = true;
        };
        panel = {
          auto_refresh = true;
        };
        suggestion = {
          auto_trigger = true;
          hide_during_completion = false;
          debounce = 50;
          keymap = {
            accept_word = "<M-l>";
            accept_line = "<M-;>";
            accept = "<M-'>";
            dismiss = "<C-'>";
            prev = "<M-j>";
            next = "<M-k>";
          };
        };
      };
    };
    oil = {
      enable = true;
      settings = {
        default_file_explorer = false;
        delete_to_trash = true;
      };
    };
    web-devicons = {
      enable = true;
    };
    flash = {
      enable = true;
    };
    wrapping = {
      enable = false;
      settings = {
        softener = {
          gitcommit = true;
        };
      };
    };
  };
}
