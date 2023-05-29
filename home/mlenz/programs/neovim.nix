{extras, ...}: let
  inherit (extras) pkgsUnstable;
in {
  programs.neovim = {
    enable = true;
    package = pkgsUnstable.neovim-unwrapped;
    # TODO: new in 23.05 defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraConfig = ''
      set nocompatible

      syntax on

      set autoindent
      set ruler
      set mouse=a
      set ignorecase
      set smartcase

      set tabstop=4
      set shiftwidth=0
      set noexpandtab

      set clipboard=unnamed

      " Use 'jk' to enter insert mode
      inoremap jk <esc>

      " Use 'return' to clear the highlighting of the last search
      " https://stackoverflow.com/a/662914
      " nnoremap <CR> :noh<CR><CR>

      " Use 'shift+return' to prepend new line
      nmap <S-Enter> O<Esc>

      " Use 'return' to append new line
      nmap <CR> o<Esc>

      " Do not yank deleted content
      nnoremap d "_d
      vnoremap d "_d

      colorscheme slate

      if !has('nvim')
        set ttymouse=xterm2
      endif

      if has('nvim')
        tnoremap <Esc> <C-\><C-n>
      endif
    '';
  };
}
