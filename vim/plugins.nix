{ config, ... }:
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
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          ghost_text = {
            enabled = true;
          };
          documentation = {
            auto_show = true;
          };
          keyword = {
            range = "full";
          };
          menu.draw.components.label.width = {
            fill = true;
            max = 120;
          };
        };
        appearance = {
          kind_icons = { };
        };
        keymap = {
          preset = "enter";
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            # "luasnip"
            # "buffer"
            "copilot"
          ];
          providers = {
            copilot = {
              async = true;
              module = "blink-copilot";
              name = "Copilot";
              score_offset = 100;
              opts = { };
            };
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 15;
              opts = { };
            };
          };
        };
      };
    };
    blink-copilot = {
      inherit (config.plugins.blink-cmp) enable;
    };
    blink-emoji = {
      inherit (config.plugins.blink-cmp) enable;
    };
    cmp = {
      enable = false;
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
          { name = "copilot"; }
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
    copilot-cmp = {
      inherit (config.plugins.cmp) enable;
    };
    copilot-lua = {
      enable = true;
      settings = {
        filetypes = {
          "*" = true;
        };
        panel = {
          enabled = false;
          auto_refresh = true;
        };
        suggestion = {
          enabled = false;
          auto_trigger = true;
          hide_during_completion = false;
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
