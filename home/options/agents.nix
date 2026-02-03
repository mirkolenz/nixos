{
  lib,
  config,
  ...
}:
let
  cfg = config.programs.agents;
  mkSkillFiles =
    prefix:
    lib.concatMapAttrs (
      name: files:
      lib.mapAttrs' (
        file: content: lib.nameValuePair "${prefix}/${name}/${file}" { text = content; }
      ) files
    ) cfg.skills;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.agents = {
    enable = lib.mkEnableOption "agents";

    instructions = lib.mkOption {
      type = lib.types.lines;
      default = { };
    };

    skills = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.lines);
      default = { };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf (cfg.instructions != { }) {
        xdg.configFile = {
          "amp/AGENTS.md".text = cfg.instructions;
          "crush/CRUSH.md".text = cfg.instructions;
          "opencode/AGENTS.md".text = cfg.instructions;
        };
        home.file = {
          ".claude/CLAUDE.md".text = cfg.instructions;
          ".codex/AGENTS.md".text = cfg.instructions;
          ".gemini/GEMINI.md".text = cfg.instructions;
        };
      })
      (lib.mkIf (cfg.skills != { }) {
        xdg.configFile = lib.mergeAttrsList (
          map mkSkillFiles [
            "agents/skills" # amp
            "opencode/skills"
          ]
        );
        home.file = lib.mergeAttrsList (
          map mkSkillFiles [
            ".claude/skills"
            ".codex/skills"
            ".gemini/skills"
          ]
        );
      })
    ]
  );
}
