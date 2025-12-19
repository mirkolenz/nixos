{ ... }:
{
  programs.agents-md = {
    enable = true;
    settings.body = /* markdown */ ''
      ## General

      - Use conventional commit messages to describe changes so that semantic versioning can be applied.
      - In plain text files, write exactly one sentence per line: txt, md, tex, typ, rst, ...
      - Do not run formatters or linters automatically, only when explicitly needed.
      - Favor simple and readable solutions over complex ones and optimize for maintainability.

      ## Python

      - Use `uv run` to execute Python scripts and files, not `python` or `python3`.
      - Use `ruff check --fix --unsafe-fixes --output-format=concise` without uv for linting Python code, not `flake8` or `pylint`.
      - Use `ty --output-format=concise` without uv for type checking Python code, not `mypy` or `pyright`.
      - Use a src-based layout for Python projects.
      - Add type annotations to Python functions and classes.
      - Add `__all__` to public modules to control what is exported.
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
}
