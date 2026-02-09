{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  # https://code.claude.com/docs/en/permissions
  # https://code.claude.com/docs/en/sandboxing
  # https://code.claude.com/docs/en/settings
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code-bin;
    settings = {
      model = "opus";
      effort = "high";
      cleanupPeriodDays = 30;
      enableAllProjectMcpServers = true;
      forceLoginMethod = "claudeai";
      includeCoAuthoredBy = false;
      sandbox = {
        enabled = true;
        excludedCommands = [ "nix" ];
        # todo: does not work as of 2026-02-08
        network.allowUnixSockets = [ "/nix/var/nix/daemon-socket/socket" ];
      };
      env = {
        CLAUDE_CODE_SUBAGENT_MODEL = "sonnet";
        UV_NO_SYNC = "1";
        # todo
        # https://github.com/anthropics/claude-code/issues/17989
        # https://github.com/anthropics/claude-code/issues/22667
        # https://github.com/anthropics/claude-code/issues/22667
        TMPDIR = "/tmp/claude";
        TMPPREFIX = "/tmp/claude/zsh";
        # https://astro.build/telemetry/
        ASTRO_TELEMETRY_DISABLED = "1";
      };
      permissions = {
        defaultMode = "acceptEdits";
        disableBypassPermissionsMode = "disable";
        # absolute paths need // prefix, otherwise they are treated as relative to the project root
        allow = [
          "WebFetch"
          "WebSearch"
          "Edit(/${config.xdg.cacheHome}/**)"
          "Edit(/${config.home.homeDirectory}/.npm/**)"
          "Bash(nix *)"
          "Bash(uv run pytest *)" # calls stat() which conflicts with .env deny
        ];
        deny = [
          "Bash(sudo *)"
          "Read(.env*)"
          "Read(*secret*)"
          "Bash(nix run *)"
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
  };
  # the native installer expects the binary to be at this location
  # otherwise an error is shown in the interface
  xdg.binFile.claude.source = lib.getExe pkgs.claude-code-bin;
}
