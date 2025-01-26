{ ... }:
{
  programs.starship = {
    enable = true;
    # enableTransience = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[🗙](bold red)";
      };
      container.format = "[$symbol]($style) ";
      direnv.disabled = false;
    };
    # Disable nerd fonts: starship preset no-nerd-font
    settings = {
      battery = {
        full_symbol = "• ";
        charging_symbol = "⇡ ";
        discharging_symbol = "⇣ ";
        unknown_symbol = "❓ ";
        empty_symbol = "❗ ";
      };
      erlang.symbol = "ⓔ ";
      nodejs.symbol = "[⬢](bold green) ";
      pulumi.symbol = "🧊 ";
    };
  };
}
