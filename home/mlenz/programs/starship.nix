{lib, ...}: {
  programs.starship = lib.mkMerge [
    {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[🗙](bold red)";
        };
      };
    }
    (lib.optionalAttrs (lib.versionAtLeast lib.trivial.release "23.11") {
      enableTransience = true;
    })
  ];
}
