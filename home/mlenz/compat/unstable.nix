{
  lib,
  pkgs,
  user,
  unstableVersion,
  ...
}:
lib.optionalAttrs (lib.versionAtLeast lib.trivial.release unstableVersion) {
  programs = {
    zsh.syntaxHighlighting.enable = true;
    carapace = {
      enable = true;
    };
    ripgrep = {
      enable = true;
    };
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = user.name;
          email = user.mail;
        };
      };
    };
    thefuck = {
      enable = true;
    };
    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--long"
        "--group-directories-first"
        "--color=always"
        "--time-style=long-iso"
      ];
      git = true;
      icons = true;
    };
    nixvim = {
      defaultEditor = true;
      keymaps = [
        {
          # Use 'jk' to exit insert mode
          key = "jk";
          mode = "i";
          action = ''<esc>'';
        }
        {
          # Use 'shift+return' to prepend new line
          key = "<S-Enter>";
          mode = "n";
          action = ''O<Esc>'';
        }
        {
          # Use 'return' to append new line
          key = "<CR>";
          mode = "n";
          action = ''o<Esc>'';
        }
        {
          # Do not yank deleted content (normal mode)
          key = "d";
          mode = "n";
          action = ''"_d'';
        }
        {
          # Do not yank deleted content (visual mode)
          key = "d";
          mode = "v";
          action = ''"_d'';
        }
        {
          key = "<Esc>";
          mode = "t";
          action = ''<C-\><C-n>'';
        }
      ];
    };
  };
}
