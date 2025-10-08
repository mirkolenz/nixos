{ lib, config, ... }:
{
  programs.starship = {
    enable = true;
    enableTransience = false;
    settings = lib.mkMerge (
      (lib.map
        (name: lib.importTOML "${config.programs.starship.package}/share/starship/presets/${name}.toml")
        [
          "nerd-font-symbols"
          "bracketed-segments"
        ]
      )
      ++ lib.singleton {
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
          format = lib.mkForce "\\[[$symbol$state]($style)\\]";
          impure_msg = "nix-shell";
          pure_msg = "nix-shell";
          unknown_msg = "nix-shell";
        };
      }
    );
  };
}
