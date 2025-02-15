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
      key = "<C-`>";
      mode = "n";
      action = "<cmd>terminal<CR>";
      options.desc = "Open terminal";
    }
    {
      key = "<C-`>";
      mode = "t";
      action = "<C-\\><C-n>";
      options.desc = "Close terminal";
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
      key = "<M-h>";
      mode = "i";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.silent = true;
      options.desc = "Show diagnostics";
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
