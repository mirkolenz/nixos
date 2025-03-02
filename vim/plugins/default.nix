{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins = {
    comment.enable = true;
    flash.enable = true;
    gitgutter.enable = true;
    gitignore.enable = true;
    gitsigns.enable = true;
    grug-far.enable = true;
    lualine.enable = true;
    neogit.enable = true;
    noice.enable = true;
    persistence.enable = true;
    todo-comments.enable = true;
    web-devicons.enable = true;
  };
}
