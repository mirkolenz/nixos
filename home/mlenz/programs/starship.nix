{...}: {
  programs.starship = {
    enable = true;
    # enable for 23.11
    # enableTransience = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[🗙](bold red)";
      };
    };
  };
}
