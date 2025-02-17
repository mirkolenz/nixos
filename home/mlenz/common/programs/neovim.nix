{
  pkgs,
  config,
  lib,
  ...
}:
{
  custom.neovim = {
    enable = true;
    package = pkgs.nixvim-unstable;
  };
  programs.neovide = {
    enable = config.custom.profile.isDesktop;
    settings = {
      fork = true;
      neovim-bin = lib.getExe config.custom.neovim.package;
    };
  };
  home.packages = lib.mkIf config.programs.neovide.enable [
    (pkgs.writeShellApplication {
      name = "neovide-launcher";
      text = ''
        if [ "$#" -eq 0 ]; then
          echo "Usage: $0 <file> [args...]" >&2
          exit 1
        fi
        path="$(realpath "$1")"
        shift
        if [ -f "$path" ]; then
            cd "$(dirname "$path")"
        elif [ -d "$path" ]; then
            cd "$path"
        else
            echo "Error: $path does not exist."
            exit 1
        fi

        ${lib.getExe config.programs.neovide.package} "$path" "$@"
      '';
    })
  ];
}
