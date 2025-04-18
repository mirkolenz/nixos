{
  lib',
  lib,
  config,
  ...
}:
{
  plugins.which-key = {
    enable = true;
    settings = {
      preset = "modern";
    };
  };
  keymaps = lib.mkIf config.plugins.which-key.enable (
    lib'.self.mkVimKeymaps
      {
        prefix = "require('which-key').";
        raw = true;
      }
      [
        {
          key = "<leader>?";
          action = "show({ global = false })";
          options.desc = "Buffer Local Keymaps (which-key)";
        }
      ]
  );
}
