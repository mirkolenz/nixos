{ ... }:
{
  clipboard.register = "unnamedplus";
  opts = {
    # syntax = "on";
    autoindent = true;
    confirm = true;
    expandtab = true;
    foldenable = false;
    guifont = "Berkeley\ Mono,JetBrains\ Mono:h13";
    ignorecase = true;
    linebreak = true;
    mouse = "a";
    number = true;
    ruler = true;
    shiftwidth = 2;
    smartcase = true;
    tabstop = 2;
    laststatus = 3;
  };
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    # https://neovim.io/doc/user/pi_netrw.html#netrw-noload
    # loaded_netrw = 1;
    # loaded_netrwPlugin = 1;
    neovide_input_macos_option_key_is_meta = "both";
  };
}
