{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  layouts = {
    default = ''
      tab { pane; }
    '';
    codex = ''
      tab name="💻 codex" {
        pane command="codex" close_on_exit=true
      }
    '';
    claude = ''
      tab name="💻 claude" {
        pane command="claude" close_on_exit=true
      }
    '';
    lazygit = ''
      tab name="🔍 lazygit" {
        pane command="lazygit" close_on_exit=true
      }
    '';
    nvim = ''
      tab name="⌨️ nvim" {
        pane command="nvim" close_on_exit=true
      }
    '';
  };
in
{
  programs.zellij = {
    enable = true;
    # https://zellij.dev/documentation/options.html
    settings = {
      auto_layout = true;
      copy_on_select = true;
      default_layout = "default";
      default_mode = "normal";
      on_force_close = "detach";
      pane_frames = false;
      session_serialization = false;
      show_release_notes = false;
      show_startup_tips = false;
      theme = "gruvbox-dark";
      web_server = false; # managed via launchd
    };
    # https://zellij.dev/documentation/keybindings-keys.html
    # https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl
    extraConfig = ''
      keybinds {
        shared {
          unbind "Alt f"
          bind "Alt Shift f" { ToggleFloatingPanes; }
        }
        normal {
          bind "Alt c" { Copy; }
          bind "Alt t" { NewTab; }
          bind "Alt w" { CloseTab; }
          bind "Alt g" { NewTab { layout "lazygit"; }; }
          bind "Alt v" { NewTab { layout "nvim"; }; }
          bind "Alt Tab" { GoToNextTab; }
          bind "Alt Shift Tab" { GoToPreviousTab; }
        }
      }
    '';
  };
  xdg.configFile = lib.mkMerge [
    (lib.mapAttrs' (name: value: {
      name = "zellij/layouts/${name}.kdl";
      # zellij setup --dump-layout default
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
          ${value}
        }
      '';
    }) layouts)
    {
      "zellij/themes/flexoki.kdl".source = "${pkgs.flexoki}/share/zellij/flexoki.kdl";
    }
  ];
  home.shellAliases = {
    zj = lib.getExe config.programs.zellij.package;
    zja = "${lib.getExe config.programs.zellij.package} attach";
    zjx = "${lib.getExe config.programs.zellij.package} attach --create main";
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "zjpwd";
      text = /* bash */ ''
        parent="$(basename "$(dirname "$PWD")")"
        current="$(basename "$PWD")"
        exec ${lib.getExe config.programs.zellij.package} attach --create "$parent-$current"
      '';
    })
    (pkgs.writeShellApplication {
      name = "zjz";
      text = /* bash */ ''
        cd "$(${lib.getExe config.programs.zoxide.package} query -- "$1")" || exit 1
        exec zjpwd
      '';
    })
  ];
  programs.fish.interactiveShellInit = ''
    if set -q ZELLIJ
      function _zellij_set_tab_to_cwd --on-event fish_prompt --on-event fish_postexec --on-variable PWD
        command zellij action rename-tab "📁 "(string replace -- $HOME '~' $PWD | path basename) &>/dev/null
      end

      function _zellij_set_tab_to_cmd --on-event fish_preexec
        set -l words (string split -n ' ' -- $argv[1])
        if test "$words[1]" = sudo
          set words $words[2..]
        end
        command zellij action rename-tab "🚀 $words[1]" &>/dev/null
      end
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
