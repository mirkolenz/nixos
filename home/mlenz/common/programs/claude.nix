{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf config.custom.profile.isWorkstation {
  # https://docs.anthropic.com/en/docs/claude-code/tutorials
  # https://docs.anthropic.com/en/docs/claude-code/settings
  # https://docs.anthropic.com/en/docs/claude-code/iam
  # https://github.com/dwillitzer/claude-settings
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code-bin;
    settings = {
      cleanupPeriodDays = 30;
      includeCoAuthoredBy = false;
      enableAllProjectMcpServers = true;
      permissions = {
        defaultMode = "acceptEdits";
        allow = [
          # basics
          "Bash(cat:*)"
          "Bash(echo:*)"
          "Bash(fd:*)"
          "Bash(find:*)"
          "Bash(grep:*)"
          "Bash(head:*)"
          "Bash(ls:*)"
          "Bash(mkdir:*)"
          "Bash(rg:*)"
          "Bash(tail:*)"
          "Bash(touch:*)"
          # development
          "Bash(go build:*)"
          "Bash(go run:*)"
          "Bash(latexmk:*)"
          "Bash(nix build:*)"
          "Bash(node:*)"
          "Bash(npm run:*)"
          "Bash(python3:*)"
          "Bash(python:*)"
          "Bash(typst:*)"
          "Bash(uv run:*)"
          # git
          "Bash(git add:*)"
          "Bash(git blame:*)"
          "Bash(git commit:*)"
          "Bash(git diff:*)"
          "Bash(git fetch:*)"
          "Bash(git log:*)"
          "Bash(git show:*)"
          "Bash(git status:*)"
        ];
        deny = [
          "Bash(sudo:*)"
        ];
        ask = [ ];
      };
    };
  };
  home.shellAliases = {
    opus = "claude --model opus";
    sonnet = "claude --model sonnet";
  };
}
