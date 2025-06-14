{ config, ... }:
{
  # https://docs.anthropic.com/en/docs/claude-code/tutorials
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
      # https://github.com/dwillitzer/claude-settings
      permissions = {
        allow = [
          # basics
          "Bash(awk:*)"
          "Bash(basename:*)"
          "Bash(bc:*)"
          "Bash(cat:*)"
          "Bash(cd:*)"
          "Bash(cut:*)"
          "Bash(date:*)"
          "Bash(diff:*)"
          "Bash(dirname:*)"
          "Bash(expr:*)"
          "Bash(false:*)"
          "Bash(find:*)"
          "Bash(grep:*)"
          "Bash(head:*)"
          "Bash(jq:*)"
          "Bash(less:*)"
          "Bash(ls:*)"
          "Bash(mkdir:*)"
          "Bash(more:*)"
          "Bash(popd:*)"
          "Bash(printf:*)"
          "Bash(pushd:*)"
          "Bash(pwd:*)"
          "Bash(readlink:*)"
          "Bash(realpath:*)"
          "Bash(rg:*)"
          "Bash(sed:*)"
          "Bash(seq:*)"
          "Bash(shuf:*)"
          "Bash(sort:*)"
          "Bash(tail:*)"
          "Bash(test:*)"
          "Bash(time:*)"
          "Bash(timeout:*)"
          "Bash(touch:*)"
          "Bash(tree:*)"
          "Bash(true:*)"
          "Bash(uname:*)"
          "Bash(uniq:*)"
          "Bash(watch:*)"
          "Bash(wc:*)"
          "Bash(which:*)"
          "Bash(yq:*)"
          # programs
          "Bash(nix build:*)"
          "Bash(npm run:*)"
          "Bash(uv run:*)"
          "Bash(python:*)"
          "Bash(python3:*)"
          # git
          "Bash(git add:*)"
          "Bash(git commit:*)"
          "Bash(git diff:*)"
          "Bash(git fetch:*)"
          "Bash(git log:*)"
          # others
          "Edit"
          "MultiEdit"
          "NotebookEdit"
          "WebSearch"
          "Write"
        ];
        deny = [
          "Bash(sudo:*)"
        ];
      };
    };
    # https://www.anthropic.com/engineering/claude-code-best-practices
    guidance = ''
      - If the repo has pyproject.toml and uv.lock files, always use `uv run` to run Python scripts/modules.
    '';
  };
}
