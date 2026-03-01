{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  layouts = {
    codex = ''
      pane command="fish" {
        args "-lc" "codex"
      }
    '';
    claude = ''
      pane command="fish" {
        args "-lc" "claude"
      }
    '';
  };
in
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
  programs.fish.interactiveShellInit = lib.mkIf config.custom.profile.isHeadless ''
    if set -q SSH_CONNECTION
      eval (${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | string collect)
    end
  '';
  # zellij setup --dump-layout default
  xdg.configFile = lib.mapAttrs' (name: value: {
    name = "zellij/layouts/${name}.kdl";
    value.text = ''
      layout {
        default_tab_template {
          pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
          }
          children
          pane size=1 borderless=true {
            plugin location="zellij:status-bar"
          }
        }
        tab name="lazygit" {
          pane command="lazygit"
        }
        tab name="${name}" focus=true {
          ${value}
        }
      }
    '';
  }) layouts;
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
