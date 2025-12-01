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
    # https://github.com/openai/codex/blob/main/docs/config.md
    # https://github.com/openai/codex/blob/main/codex-rs/core/src/config/mod.rs
    settings = {
      model = "gpt-5.1-codex-max";
      # model_reasoning_effort = "high";
      # model_reasoning_summary = "auto";
      approval_policy = "on-request";
      file_opener = "none";
      preferred_auth_method = "chatgpt";
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
      # https://github.com/openai/codex/blob/main/codex-rs/core/src/features.rs
      # codex features list
      features = {
        apply_patch_freeform = true;
        parallel = true;
        remote_compaction = true;
        rmcp_client = true;
        shell_command_tool = true;
        undo = true;
        view_image_tool = true;
        web_search_request = true;
      };
    };
  };
}
