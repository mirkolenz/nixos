{ ... }:
{
  programs.starship = {
    enable = true;
    presets = [ "nerd-font-symbols" ];
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };
      container.format = "[$symbol]($style) ";
      direnv = {
        format = "[$symbol$loaded]($style) ";
        symbol = " ";
        loaded_msg = "loaded";
        unloaded_msg = "unloaded";
        disabled = false;
      };
      nix_shell = {
        format = "[$symbol$state]($style) ";
        impure_msg = "nix-shell";
        pure_msg = "nix-shell";
        unknown_msg = "nix-shell";
      };
    };
  };
}
