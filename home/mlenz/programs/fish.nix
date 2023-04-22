{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      dc = "docker compose";
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      l = "exa -l";
      py = "poetry run python -m";
      hass = "hass-cli";
    };
    # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1266049484
    loginShellInit = ''
      if test (uname) = Darwin
        for p in (string split " " $NIX_PROFILES)
          fish_add_path --prepend --move $p/bin
        end
      end
    '';
    interactiveShellInit = ''
      # Disable greeting
      set fish_greeting ""
    '';
    functions = {
      dockerup = {
        body = ''
          sudo docker compose pull $argv
          sudo docker compose build $argv
          sudo docker compose up --detach
          sudo docker image prune --all --force
        '';
        description = "Update all docker-compose containers";
      };
      docker-reset = {
        body = ''
          sudo docker system prune --all --force
        '';
        description = "Reset docker";
      };
      encrypt = {
        description = "Encrypt a file using gpg";
        body = ''
          gpg --output "$target" --encrypt --recipient "$recipient" "$source"
        '';
        argumentNames = [ "source" "target" "recipient" ];
      };
      decrypt = {
        description = "Decrypt a file using gpg";
        body = ''
          gpg --output "$target" --decrypt "$source"
        '';
        argumentNames = [ "source" "target" ];
      };
      backup = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          mkdir -p "$target"
          sudo tar czf "$target/$(date +"%Y-%m-%d-%H-%M-%S").tgz" "$source"
        '';
        argumentNames = [ "source" "target" ];
      };
      restore = {
        description = "Backup a directory to a tar.gz file";
        body = ''
          mkdir -p "$target"
          sudo tar xf "$source" -C "$target"
        '';
        argumentNames = [ "source" "target" ];
      };
      divider = {
        body = ''
          set length (tput cols)
          set char =
          tput bold

          echo
          printf "%*s\n" $length "" | tr " " $char
          echo

          tput sgr0
        '';
        description = "Print a bold horizontal line";
      };
      otf2ttf = {
        body = ''
          fontforge -c 'Open("$source"); Generate("$target")'
        '';
        description = "Convert an OpenType font to TrueType";
        wraps = "fontforge";
        argumentNames = [ "source" "target" ];
      };
    };
  };
}
