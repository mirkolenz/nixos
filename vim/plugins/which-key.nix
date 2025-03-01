{ lib, ... }:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
    };
  };
  keymaps = [
    {
      key = "<leader>?";
      action = lib.nixvim.mkRaw ''
        function()
          require("which-key").show({ global = false })
        end
      '';
      options.desc = "Buffer Local Keymaps (which-key)";
    }
  ]
}
