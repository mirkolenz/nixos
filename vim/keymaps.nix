{ ... }:
{
  keymaps = [
    {
      key = "<C-v>";
      mode = "i";
      action = "<C-r>+";
      options.desc = "Paste from clipboard in insert mode";
    }
    {
      key = "d";
      mode = [
        "n"
        "v"
      ];
      action = "\"_d";
      options.desc = "Do not yank deleted content";
    }
    {
      key = "<Esc>";
      mode = "n";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlights";
    }
    {
      key = "<Esc><Esc>";
      mode = "t";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    # Use <C-[hjkl]> to switch between windows
    {
      key = "<C-h>";
      mode = "n";
      action = "<C-w>h";
      options.desc = "Switch to window on the left";
    }
    {
      key = "<C-j>";
      mode = "n";
      action = "<C-w>j";
      options.desc = "Switch to window below";
    }
    {
      key = "<C-k>";
      mode = "n";
      action = "<C-w>k";
      options.desc = "Switch to window above";
    }
    {
      key = "<C-l>";
      mode = "n";
      action = "<C-w>l";
      options.desc = "Switch to window on the right";
    }
    # Use <M-u>[aouAOU] to write Umlauts
    {
      key = "<M-u>a";
      mode = "i";
      action = "ä";
      options.desc = "Write 'ä'";
    }
    {
      key = "<M-u>o";
      mode = "i";
      action = "ö";
      options.desc = "Write 'ö'";
    }
    {
      key = "<M-u>u";
      mode = "i";
      action = "ü";
      options.desc = "Write 'ü'";
    }
    {
      key = "<M-u>A";
      mode = "i";
      action = "Ä";
      options.desc = "Write 'Ä'";
    }
    {
      key = "<M-u>O";
      mode = "i";
      action = "Ö";
      options.desc = "Write 'Ö'";
    }
    {
      key = "<M-u>U";
      mode = "i";
      action = "Ü";
      options.desc = "Write 'Ü'";
    }
  ];
}
