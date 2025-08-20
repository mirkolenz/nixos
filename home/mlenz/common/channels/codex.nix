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
    settings = {
      # approval_policy = "never"; # User is never prompted
      approval_policy = "on-request"; # The model decides when to escalate
      sandbox_mode = "workspace-write";
      sandbox_workspace_write.network_access = true;
    };
  };
}
