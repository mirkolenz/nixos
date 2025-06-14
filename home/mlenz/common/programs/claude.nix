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
      ## General

      - Use conventional commit messages to describe changes.

      ## Python

      - Use `uv run` to execute Python scripts and modules, not `python` or `python3`.
      - Use a src-based layout for Python projects.
      - Add type annotations to Python functions and classes.
      - Add `__all__` to modules to control what is exported.
      - Create tests using `pytest` and place them in a `tests/` directory.
      - Add docstrings to all public functions and classes.
      - Add doctests to functions and classes where appropriate.
      - Use the Google style for docstrings.

      ## Node.js

      - Use TypeScript, not JavaScript.
      - Use ES modules (import/export) syntax, not CommonJS (require).

      ## Nix

      - Use flakes to manage Nix projects, not channels.
      - Use flake-parts to structure flake.nix files.
    '';
  };
}
