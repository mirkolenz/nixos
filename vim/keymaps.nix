{ ... }:
{
  keymaps = [
    # {
    #   key = "jk";
    #   mode = "i";
    #   action = "<esc>";
    #   options.desc = "Use 'jk' to exit insert mode";
    # }
    {
      key = "d";
      mode = [
        "n"
        "v"
      ];
      action = ''"_d'';
      options.desc = "Do not yank deleted content";
    }
    {
      key = "<leader>gg";
      mode = "n";
      action = "<cmd>LazyGit<CR>";
      options.desc = "Open lazygit";
    }
    {
      key = "<leader>m";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>MCstart<CR>";
      options.silent = true;
      options.desc = "Start multicursor";
    }
    {
      key = "<leader>bf";
      mode = "n";
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      options.desc = "Format buffer";
    }
    {
      key = "<leader>xx";
      mode = "n";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      key = "<leader>xX";
      mode = "n";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      key = "<leader>cs";
      mode = "n";
      action = "<cmd>Trouble symbols toggle focus=false<CR>";
      options.desc = "Symbols (Trouble)";
    }
    {
      key = "<leader>cl";
      mode = "n";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
      options.desc = "LSP definitions/references/... (Trouble)";
    }
    {
      key = "<leader>xL";
      mode = "n";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Location List (Trouble)";
    }
    {
      key = "<leader>xQ";
      mode = "n";
      action = "<cmd>Trouble qflist toggle<CR>";
      options.desc = "Quickfix List (Trouble)";
    }
  ];
  # "<cmd>Telescope ${value}<CR>";
  plugins.telescope.keymaps = {
    "<leader>ff" = "find_files";
    "<leader>fg" = "live_grep";
    "<leader>fb" = "file_browser";
    "<leader>fh" = "help_tags";
  };
}
