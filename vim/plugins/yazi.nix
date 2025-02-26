{ ... }:
{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
    };
  };
  keymaps = [
    {
      key = "<leader>yf";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>Yazi<CR>";
      options.desc = "Open yazi at current file";
    }
    {
      key = "<leader>yd";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>Yazi cwd<CR>";
      options.desc = "Open yazi in current working directory";
    }
    {
      key = "<leader>yt";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>Yazi toggle<CR>";
      options.desc = "Resume last yazi session";
    }
  ];
}
