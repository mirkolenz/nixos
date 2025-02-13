{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin rec {
      pname = "github-theme";
      version = "1.1.2";
      src = pkgs.fetchFromGitHub {
        owner = "projekt0n";
        repo = "github-nvim-theme";
        tag = "v${version}";
        hash = "sha256-ur/65NtB8fY0acTUN/Xw9fT813UiL3YcP4+IwkaUzTE=";
      };
    })
  ];
  extraConfigLua = ''
    require('github-theme')
    vim.cmd('colorscheme github_dark_default')
  '';
  colorschemes = {
    monokai-pro = {
      enable = false;
      settings = {
        filter = "spectrum";
      };
    };
    catppuccin = {
      enable = false;
      settings = {
        background = {
          light = "latte";
          dark = "mocha";
        };
      };
    };
  };
}
