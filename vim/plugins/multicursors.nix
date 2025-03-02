{ ... }:
{
  plugins.multicursors = {
    enable = true;
  };
  keymaps = [
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
