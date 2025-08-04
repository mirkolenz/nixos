{
  lib',
  lib,
  config,
  ...
}:
let
  cfg = config.programs.agents-md;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.agents-md = {
    enable = lib.mkEnableOption "AGENTS.md";

    settings = lib.mkOption {
      type = lib'.self.mdFormat;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "crush/CRUSH.md".text = cfg.settings.text;
      "opencode/AGENTS.md".text = cfg.settings.text;
    };
    home.file = {
      ".claude/CLAUDE.md".text = cfg.settings.text;
      ".codex/AGENTS.md".text = cfg.settings.text;
      ".gemini/GEMINI.md".text = cfg.settings.text;
    };
  };
}
