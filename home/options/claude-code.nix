{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    ;

  configFormat = pkgs.formats.json { };
  cfg = config.programs.claude-code;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.claude-code = {
    enable = mkEnableOption "claude-code";

    package = mkPackageOption pkgs "claude-code" { nullable = true; };

    settings = mkOption {
      type = configFormat.type;
      default = { };
      description = ''
        Configuration written to
        {file}`$HOME/.claude/settings.json`.
        See <https://docs.anthropic.com/en/docs/claude-code/settings>
        for more information.
      '';
    };

    guidance = lib.mkOption {
      type = lib.types.lines;
      description = ''
        Define custom guidance for the agents.
        Written to {file}`$HOME/.claude/CLAUDE.md`
      '';
      default = "";
    };

    commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.lines;
      default = { };
      description = ''
        Personal slash commands written to
        {file}`$HOME/.claude/commands/$name.md`.
        For nested commands, use "namespace/name"
        as the key.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file = lib.mkMerge [
      {
        ".claude/settings.json" = lib.mkIf (cfg.settings != { }) {
          source = configFormat.generate "claude-settings" cfg.settings;
        };
        ".claude/CLAUDE.md" = lib.mkIf (cfg.guidance != "") {
          text = cfg.guidance;
        };
      }
      (lib.mapAttrs' (name: text: {
        name = ".claude/commands/${name}.md";
        value = { inherit text; };
      }) cfg.commands)
    ];
  };
}
