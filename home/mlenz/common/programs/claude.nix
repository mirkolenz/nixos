{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  # https://code.claude.com/docs/en/iam
  # https://code.claude.com/docs/en/sandboxing
  # https://code.claude.com/docs/en/settings
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code-bin;
    settings = {
      cleanupPeriodDays = 30;
      enableAllProjectMcpServers = true;
      forceLoginMethod = "claudeai";
      includeCoAuthoredBy = false;
      sandbox = {
        enabled = true;
        autoAllowBashIfSandboxed = true;
      };
      env = {
        UV_NO_SYNC = "1";
      };
      permissions = {
        defaultMode = "acceptEdits";
        disableBypassPermissionsMode = "disable";
        allow = [
          "WebFetch"
          "WebSearch"
          "Edit(${config.xdg.cacheHome}/**)"
          "Edit(${config.home.homeDirectory}/.npm/**)"
        ];
        deny = [
          "Bash(sudo:*)"
          "Read(.env*)"
          "Read(*secret*)"
        ];
        ask = [ ];
      };
    };
  };
  # https://code.claude.com/docs/en/model-config
  home.shellAliases = {
    opus = "claude --model opus";
    sonnet = "claude --model sonnet";
    haiku = "claude --model haiku";
    opusplan = "claude --model opusplan";
  };
  # the native installer expects the binary to be at this location
  # otherwise an error is shown in the interface
  xdg.binFile.claude.source = lib.getExe pkgs.claude-code-bin;
}
