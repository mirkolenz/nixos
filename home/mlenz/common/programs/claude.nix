{ config, ... }:
{
  programs.claude-code = {
    enable = config.custom.profile.isWorkstation;
    settings = {
      autoUpdaterStatus = "disabled";
      cleanupPeriodDays = 30;
      includeCoAuthoredBy = false;
      model = "sonnet";
      preferredNotifChannel = "terminal_bell";
      theme = "dark";
      verbose = false;
      env = {
        CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = "1";
      };
      permissions = {
        allow = [
          "Edit"
          "MultiEdit"
          "NotebookEdit"
          "WebSearch"
          "Write"
        ];
        deny = [ ];
      };
    };
    guidance = ''
      I use `uv` to manage Python projects, so instead of `python` always use `uv run python`.
    '';
  };
}
