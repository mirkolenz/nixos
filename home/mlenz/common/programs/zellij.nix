{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zellij = {
    enable = true;
    settings = {
      auto_layout = true;
      default_layout = "default";
      default_mode = "normal";
      on_force_close = "quit";
      session_serialization = false;
      show_release_notes = false;
      show_startup_tips = false;
      theme = "default";
      web_server = false; # managed via launchd
    };
  };
  home.sessionVariables = {
    ZELLIJ_AUTO_ATTACH = "1";
    ZELLIJ_AUTO_EXIT = "1";
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "zellijd";
      text = /* bash */ ''
        exec ${lib.getExe config.programs.zellij.package} attach --create "$(basename "$PWD")"
      '';
    })
  ];
  programs.fish.interactiveShellInit = ''
    if set -q ZELLIJ
      function _zellij_current_dir
        if test "$PWD" = "$HOME"
          echo "~"
        else
          echo (basename $PWD)
        end
      end

      function _zellij_change_tab_title
        command nohup zellij action rename-tab $argv[1] >/dev/null 2>&1
      end

      function _zellij_set_tab_to_working_dir --on-event fish_prompt
        _zellij_change_tab_title (_zellij_current_dir)
      end

      function _zellij_set_tab_to_command_line --on-event fish_preexec
        _zellij_change_tab_title $argv[1]
      end
    end
  ''
  + lib.optionalString config.custom.profile.isHeadless ''
    if set -q SSH_CONNECTION
      eval (${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | string collect)
    end
  '';
  # Zellij web server
  launchd.agents.zellij-web = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = false;
    config = {
      ProgramArguments = [
        (lib.getExe config.programs.zellij.package)
        "web"
        "--start"
        "--ip"
        "127.0.0.1"
        "--port"
        "8082"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      WorkingDirectory = config.home.homeDirectory;
      EnvironmentVariables = {
        HOME = config.home.homeDirectory;
        USER = config.home.username;
        SHELL = lib.getExe config.programs.fish.package;
        LANG = "en_US.UTF-8";
        TERM = "xterm-256color";
        PATH = lib.replaceStrings [ "$HOME" "$USER" ] [ config.home.homeDirectory config.home.username ] (
          osConfig.environment.systemPath or (lib.makeBinPath [ config.home.profileDirectory ])
        );
      };
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/zellij-web.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/zellij-web.err.log";
    };
  };
}
