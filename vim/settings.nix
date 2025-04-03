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
    spell = true;
    spelllang = "en_us,de_de";
    spelloptions = "camel";
    splitbelow = true;
    splitright = true;
    tabstop = 2;
  };
  globals = {
    mapleader = " ";
    maplocalleader = " ";
    # https://neovim.io/doc/user/pi_netrw.html#netrw-noload
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
    # neovide
    neovide_input_macos_option_key_is_meta = "both";
    # https://neovide.dev/faq.html#how-to-turn-off-all-animations
    neovide_cursor_animate_command_line = false;
    neovide_cursor_animate_in_insert_mode = false;
    neovide_cursor_animation_length = 0;
    neovide_cursor_trail_size = 0;
    neovide_position_animation_length = 0;
    neovide_scroll_animation_far_lines = 0;
    neovide_scroll_animation_length = 0;
  };
}
