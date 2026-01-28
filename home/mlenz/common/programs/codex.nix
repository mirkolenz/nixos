{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  programs.codex = {
    enable = true;
    package = pkgs.codex-bin;
    # https://developers.openai.com/codex/config-reference
    settings = {
      model = "gpt-5.2-codex";
      # model_reasoning_effort = "high";
      # model_reasoning_summary = "auto";
      approval_policy = "on-request";
      file_opener = "none";
      preferred_auth_method = "chatgpt";
      check_for_update_on_startup = false;
      sandbox_mode = "workspace-write";
      sandbox_workspace_write = {
        network_access = true;
        writable_roots = [
          config.xdg.cacheHome
          "${config.home.homeDirectory}/.npm"
        ];
      };
      tui.notifications = true;
      shell_environment_policy = {
        set = {
          UV_NO_SYNC = "1";
        };
      };
      # codex features list
      # https://github.com/openai/codex/blob/main/codex-rs/core/src/features.rs
      features = {
        apply_patch_freeform = true;
        collaboration_modes = true;
        shell_snapshot = true;
        steer = true;
        unified_exec = true;
        web_search_cached = true;
      };
    };
  };
}
