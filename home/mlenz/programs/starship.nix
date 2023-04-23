{ extras, lib, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = '[❯](bold green)';
        error_symbol = '[🗙](bold red)';
      };
    };
  };
}
