{ ... }:
{
  programs.eza = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--long"
      "--group-directories-first"
      "--color=always"
      "--time-style=long-iso"
    ];
    git = true;
    icons = false; # requires nerd fonts
  };
}
