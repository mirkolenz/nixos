{...}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[🗙](bold red)";
      };
    };
  };
}
