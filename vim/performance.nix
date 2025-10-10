{ ... }:
{
  performance = {
    byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "blink.cmp"
        "nvim-treesitter"
      ];
    };
  };
}
