{ config, ... }:
{
  programs.codex = {
    enable = config.custom.profile.isWorkstation;
    settings = {
      model = "codex-mini-latest";
    };
  };
}
