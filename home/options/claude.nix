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

  tomlFormat = pkgs.formats.json { };
  cfg = config.programs.claude;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.claude = {
    enable = mkEnableOption "claude-code";

    package = mkPackageOption pkgs "claude-code" { nullable = true; };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      description = ''
        Configuration written to
        {file}`$HOME/.claude/settings.json`.
        See <https://docs.anthropic.com/en/docs/claude-code/settings>
        for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file.".claude/settings.json" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "claude-settings" cfg.settings;
    };
  };
}
