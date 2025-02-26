{ ... }:
{
  plugins.mini = {
    enable = true;
    modules = {
      misc = { };
    };
    luaConfig.post = ''
      MiniMisc.setup_auto_root()
    '';
  };
}
