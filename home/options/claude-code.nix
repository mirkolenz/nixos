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
    types
    ;

  jsonFormat = pkgs.formats.json { };
  mdFormat = types.submodule (
    { config, ... }:
    {
      options = {
        metadata = mkOption {
          type = jsonFormat.type;
          default = { };
          description = "Frontmatter for the markdown file, written as YAML.";
        };
        body = mkOption {
          type = types.lines;
          description = "Markdown content for the file.";
        };
        text = mkOption {
          type = types.str;
          readOnly = true;
        };
      };
      config = {
        text =
          if config.metadata == { } then
            config.body
          else
            ''
              ---
              ${lib.strings.toJSON config.metadata}
              ---

              ${config.body}
            '';
      };
    }
  );

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

    memory = lib.mkOption {
      type = types.lines;
      description = ''
        Define custom guidance for claude.
        Written to {file}`$HOME/.claude/CLAUDE.md`
      '';
      default = "";
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
        ".claude/CLAUDE.md" = lib.mkIf (cfg.memory != "") {
          text = cfg.memory;
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
