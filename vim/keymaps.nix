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
      action = ''"_d'';
      options.desc = "Do not yank deleted content";
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
  ];
}
