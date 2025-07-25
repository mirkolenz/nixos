{
  config,
  pkgs,
  lib,
  ...
}:
{
  # https://docs.anthropic.com/en/docs/claude-code/tutorials
  # https://docs.anthropic.com/en/docs/claude-code/settings
  # https://docs.anthropic.com/en/docs/claude-code/iam
  # https://github.com/dwillitzer/claude-settings
  programs.claude-code = lib.mkIf config.custom.profile.isWorkstation {
    enable = true;
    package = pkgs.claude-code-bin;
    settings = {
      cleanupPeriodDays = 30;
      includeCoAuthoredBy = false;
      model = "default";
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
      };
    };
    # https://www.anthropic.com/engineering/claude-code-best-practices
    guidance = ''
      ## General

      - Prefer all other available tools over the `Bash` tool and only use it when necessary.
      - Use conventional commit messages to describe changes so that semantic versioning can be applied.
      - In plain text files, write exactly one sentence per line: txt, md, tex, typ, rst, ...

      ## Python

      - Use `uv run` to execute Python scripts and modules, not `python` or `python3`.
      - Use `ruff` for linting and formatting Python code, not `black` or `flake8`.
      - Use `basedpyright` for type checking Python code, not `mypy` or `pyright`.
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

      ## LaTeX

      - Use `latexmk` to compile documents.
      - Use `cref` for cross-referencing, not `ref`.

    '';
  };
  home.shellAliases = {
    opus = "claude --model opus";
    sonnet = "claude --model sonnet";
  };
}
