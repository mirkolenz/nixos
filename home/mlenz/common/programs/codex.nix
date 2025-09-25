{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.codex = lib.mkIf config.custom.profile.isWorkstation {
    enable = true;
    package = pkgs.codex-bin;
    # https://github.com/openai/codex/blob/main/docs/config.md#config-reference
    settings = {
      model = "gpt-5-codex";
      # model_reasoning_effort = "high";
      # model_reasoning_summary = "auto";
      # approval_policy = "never"; # User is never prompted
      approval_policy = "on-request"; # The model decides when to escalate
      file_opener = "none";
      preferred_auth_method = "chatgpt";
      sandbox_mode = "workspace-write";
      sandbox_workspace_write = {
        network_access = true;
        writable_roots = [
          config.xdg.cacheHome
        ];
      };
      tools = {
        web_search = true;
      };
      tui = {
        notifications = true;
      };
    };
  };
}
