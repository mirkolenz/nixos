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
  # https://www.schemastore.org/claude-code-settings.json
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code-bin;
    settings = {
      model = "opus";
      effortLevel = "high";
      cleanupPeriodDays = 30;
      enableAllProjectMcpServers = true;
      forceLoginMethod = "claudeai";
      includeCoAuthoredBy = false;
      includeGitInstructions = false;
      spinnerTipsEnabled = false;
      sandbox = {
        enabled = true;
        allowUnsandboxedCommands = false;
        enableWeakerNetworkIsolation = true;
        excludedCommands = [
          "nix:*"
        ];
        network = {
          allowUnixSockets = [
            "/nix/var/nix/daemon-socket/socket"
          ];
          allowedDomains = [
            "github.com"
            "api.github.com"
            "raw.githubusercontent.com"
            "pypi.org"
            "files.pythonhosted.org"
            "huggingface.co"
            "registry.npmjs.org"
          ];
        };
        # absolute paths need // prefix, otherwise they are treated as relative to the project root
        filesystem = {
          allowWrite = [
            "/${config.xdg.cacheHome}"
            "/${config.home.homeDirectory}/.npm"
          ];
          # denyRead = [
          #   ".env*"
          #   "*secret*"
          # ];
        };
      };
      extraKnownMarketplaces = {
        claude-plugins-official = {
          source = {
            source = "github";
            repo = "anthropics/claude-plugins-official";
          };
        };
      };
      enabledPlugins = {
        "code-simplifier@claude-plugins-official" = true;
        "feature-dev@claude-plugins-official" = true;
        "frontend-design@claude-plugins-official" = true;
        "ralph-loop@claude-plugins-official" = true;
      };
      env = {
        # better results, but too many tokens
        # ANTHROPIC_DEFAULT_HAIKU_MODEL = "sonnet";
        ENABLE_CLAUDEAI_MCP_SERVERS = "0";
        ASTRO_TELEMETRY_DISABLED = "1";
      };
      permissions = {
        defaultMode = "acceptEdits";
        disableBypassPermissionsMode = "disable";
        allow = [
          "WebFetch"
          "WebSearch"
          "Read(//nix/store/**/*)"
        ];
        deny = [ ];
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
}
