{ lib', ... }:
{
  plugins.yazi = {
    enable = true;
    settings = {
      enable_mouse_support = true;
    };
  };
  keymaps =
    lib'.self.mkVimKeymaps
      {
        prefix = "Yazi ";
        raw = false;
      }
      [
        {
          key = "<leader>yf";
          mode = [
            "n"
            "v"
          ];
          action = "";
          options.desc = "Open yazi at current file";
        }
        {
          key = "<leader>yd";
          mode = [
            "n"
            "v"
          ];
          action = "cwd";
          options.desc = "Open yazi in current working directory";
        }
        {
          key = "<leader>yy";
          mode = [
            "n"
            "v"
          ];
          action = "toggle";
          options.desc = "Resume last yazi session";
        }
      ];
}
