{ ... }:
{
  keymaps = [
    {
      # Use 'jk' to exit insert mode
      key = "jk";
      mode = "i";
      action = "<esc>";
    }
    {
      # Use 'shift+return' to prepend new line
      key = "<S-Enter>";
      mode = "n";
      action = "O<Esc>";
    }
    {
      # Use 'return' to append new line
      key = "<CR>";
      mode = "n";
      action = "o<Esc>";
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
      action = "<C-\\><C-n>";
    }
  ];
}
