{ config, lib', ... }:
{
  imports = lib'.flocken.getModules ./.;
  plugins = {
    comment = {
      enable = true;
    };
    todo-comments = {
      enable = true;
    };
    trouble = {
      enable = true;
    };
    multicursors = {
      enable = true;
    };
    neogit = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
    gitgutter = {
      enable = true;
    };
    gitsigns = {
      enable = true;
    };
    gitignore = {
      enable = true;
    };
    copilot-cmp = {
      inherit (config.plugins.cmp) enable;
    };
    web-devicons = {
      enable = true;
    };
    flash = {
      enable = true;
    };
    wrapping = {
      enable = false;
      settings = {
        softener = {
          gitcommit = true;
        };
      };
    };
  };
}
