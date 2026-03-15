{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.custom.features.withOptionals {
  programs.codex = {
    enable = true;
    package = pkgs.codex-bin;
    # https://developers.openai.com/codex/config-reference
    # https://developers.openai.com/codex/config-schema.json
    settings = {
      model = "gpt-5.4";
      model_reasoning_effort = "xhigh";
      plan_mode_reasoning_effort = "xhigh";
      approval_policy = "on-request";
      file_opener = "none";
      preferred_auth_method = "chatgpt";
      check_for_update_on_startup = false;
      personality = "pragmatic";
      sandbox_mode = "workspace-write";
      web_search = "live";
      sandbox_workspace_write = {
        network_access = true;
        writable_roots = [
          config.xdg.cacheHome
          "${config.home.homeDirectory}/.npm"
        ];
      };
      tui = {
        alternate_screen = "never";
        notifications = true;
      };
      shell_environment_policy = {
        set = {
          ASTRO_TELEMETRY_DISABLED = "1";
        };
      };
      # codex features list
      # https://github.com/openai/codex/blob/main/codex-rs/core/src/features.rs
      features = {
        js_repl = true;
        multi_agent = true;
        prevent_idle_sleep = true;
        shell_snapshot = true;
      };
    };
  };
}
