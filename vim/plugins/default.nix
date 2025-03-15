{ lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins = {
    comment.enable = true;
    diffview.enable = true;
    flash.enable = true;
    git-conflict.enable = true;
    gitgutter.enable = true;
    gitignore.enable = true;
    gitsigns.enable = true;
    grug-far.enable = true;
    neogit.enable = true;
    noice.enable = true;
    nvim-autopairs.enable = true;
    persistence.enable = true;
    todo-comments.enable = true;
    web-devicons.enable = true;
  };
}
