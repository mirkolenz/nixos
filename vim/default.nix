# https://nix-community.github.io/nixvim/
{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;

  viAlias = true;
  vimAlias = true;
  enableMan = true;

  # load ~/.config/nvim/init.lua for faster development iteration
  impureRtp = true;
  extraConfigLua = ''
    local init_lua_path = vim.fn.stdpath('config') .. '/init.lua'

    if vim.fn.filereadable(init_lua_path) == 1 then
      vim.cmd('luafile ' .. init_lua_path)
    end
  '';

  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
  withPerl = true;
}
