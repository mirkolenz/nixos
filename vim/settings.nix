{ ... }:
{
  clipboard.register = "";
  opts = {
    autoindent = true;
    breakindent = true;
    confirm = true;
    cursorline = true;
    expandtab = true;
    foldenable = false;
    guifont = "JetBrainsMono_Nerd_Font:h13";
    ignorecase = true;
    inccommand = "split";
    laststatus = 3;
    linebreak = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    ruler = true;
    scrolloff = 10;
    shiftwidth = 2;
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    splitbelow = true;
    splitright = true;
    tabstop = 2;
  };
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    neovide_input_macos_option_key_is_meta = "both";
    # https://neovim.io/doc/user/pi_netrw.html#netrw-noload
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };
}
