{
  pkgs,
  config,
  lib,
  lib',
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  jsonFormat = pkgs.formats.json { };
  mdFormat = lib'.self.mdFormat;

  cfg = config.programs.claude-code;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.claude-code = {
    enable = mkEnableOption "claude-code";

    package = mkPackageOption pkgs "claude-code" { nullable = true; };

    settings = mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Configuration written to
        {file}`$HOME/.claude/settings.json`.
        See <https://docs.anthropic.com/en/docs/claude-code/settings>
        for more information.
      '';
    };

    commands = lib.mkOption {
      type = types.attrsOf mdFormat;
      default = { };
      description = ''
        Personal slash commands written to
        {file}`$HOME/.claude/commands/$name.md`.
        For nested commands, use "namespace/name"
        as the key.
      '';
    };

    agents = lib.mkOption {
      type = types.attrsOf mdFormat;
      default = { };
      description = ''
        Define custom agents.
        Written to {file}`$HOME/.claude/agents/$name.md`.
        For nested agents, use "namespace/name"
        as the key.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file = lib.mkMerge [
      {
        ".claude/settings.json" = lib.mkIf (cfg.settings != { }) {
          source = jsonFormat.generate "claude-settings" cfg.settings;
        };
      }
      (lib.mapAttrs' (name: value: {
        name = ".claude/commands/${name}.md";
        value = { inherit (value) text; };
      }) cfg.commands)
      (lib.mapAttrs' (name: value: {
        name = ".claude/agents/${name}.md";
        value = { inherit (value) text; };
      }) cfg.agents)
    ];
  };
}
