{ config, ... }:
{
  programs.claude-code = {
    enable = config.custom.profile.isWorkstation;
    guidance = ''
      I use `uv` to manage Python projects, so instead of `python` always use `uv run python`.
    '';
  };
}
