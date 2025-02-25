{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins = {
    bufferline.enable = true;
    comment.enable = true;
    flash.enable = true;
    gitgutter.enable = true;
    gitignore.enable = true;
    gitsigns.enable = true;
    grug-far.enable = true;
    lazygit.enable = true;
    lualine.enable = true;
    multicursors.enable = true;
    neogit.enable = true;
    noice.enable = true;
    todo-comments.enable = true;
    trouble.enable = true;
    web-devicons.enable = true;
  };
}
