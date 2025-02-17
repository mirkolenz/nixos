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
  ];
  # "<cmd>Telescope ${value}<CR>";
  plugins.telescope.keymaps = {
    "<leader>ff" = "find_files";
    "<leader>fg" = "live_grep";
    "<leader>fb" = "file_browser";
    "<leader>fh" = "help_tags";
  };
}
