{
  writeShellApplication,
  lib,
  neovide,
  nixvim,
}:
writeShellApplication {
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

    ${lib.getExe neovide} \
      --neovim-bin "${lib.getExe nixvim}" \
      "$path" "$@"
  '';
}
