{ ... }:
{
  programs.agents = {
    enable = true;
    instructions = /* markdown */ ''
      ## General

      - Use conventional commit messages to describe changes so that semantic versioning can be applied.
      - In plain text files, write exactly one sentence per line: txt, md, tex, typ, rst, ...
      - Do not run formatters or linters automatically, only when explicitly needed.
      - Favor simple and readable solutions over complex ones and optimize for maintainability.

      ## Python

      - Use `uv run` to execute Python scripts and files, not `python` or `python3`.
      - Use `uv run ruff check` for linting Python, not `flake8` or `pylint`.
      - Use `uv run ty check` AND `uv run basedpyright --level error` for type checking Python, not `mypy` or `pyright`.
      - Use a src-based layout for Python projects.
      - Add type annotations to Python functions and classes.
      - Add `__all__` to public modules to control what is exported.
      - Create tests using `pytest` and place them in a `tests/` directory.
      - Add docstrings to all public functions and classes.
      - Add doctests to functions and classes where appropriate.
      - Use the Google style for docstrings.
      - Never use globals in Python.
      - Prefer dataclasses over regular classes for data structures.
      - Always use `slots=True` for dataclasses and set `frozen=True` when possible.
      - Prefer `__post_init__` over `__init__` to customize dataclass initialization.
      - Always use types from `collections.abc` for annotating function parameters.
      - Prefer `pathlib` over `os` for file system operations.

      ## Node.js

      - Use TypeScript, not JavaScript.
      - Use ES modules (import/export) syntax, not CommonJS (require).
      - Use `npm run` to execute scripts, not `npx`.
      - Use the command `shadcn` for shadcn/ui, not `npx shadcn`.
      - Use `npm run build` to build projects, not `npm run dev` or `npm run start`.

      ## Nix

      - Use flakes to manage Nix projects, not channels.
      - Use flake-parts to structure flake.nix files.

      ## LaTeX

      - Use `latexmk` to compile documents.
      - Use `cref` for cross-referencing, not `ref`.
    '';
  };
}
