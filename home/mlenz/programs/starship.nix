{...}: {
  programs.starship = {
    enable = true;
    # enable for 23.11
    # TODO: https://discourse.nixos.org/t/sharing-a-nixos-module-codebase-across-nixos-versions/14091/5?u=mirkolenz
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
