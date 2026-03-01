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
    ZELLIJ_AUTO_ATTACH = if config.custom.profile.isDesktop then "0" else "1";
    ZELLIJ_AUTO_EXIT = "1";
  };
  xdg.configFile = {
    "zellij/layouts/codex.kdl".text = ''
      layout {
        pane command="fish" {
          args "-lc" "codex"
        }
      }
    '';
    "zellij/layouts/claude.kdl".text = ''
      layout {
        pane command="fish" {
          args "-lc" "claude"
        }
      }
    '';
  };
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
