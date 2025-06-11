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

  configFormat = pkgs.formats.toml { };
  cfg = config.programs.codex-rs;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.codex-rs = {
    enable = mkEnableOption "codex-rs";

    package = mkPackageOption pkgs "codex-rs" { nullable = true; };

    settings = mkOption {
      type = configFormat.type;
      default = { };
      description = ''
        Configuration written to
        {file}`$HOME/.codex/config.toml`.
        See <https://github.com/openai/codex>
        for more information.
      '';
    };

    guidance = lib.mkOption {
      type = lib.types.lines;
      description = ''
        Define custom guidance for the agents.
        Written to {file}`$HOME/.codex/AGENTS.md`
      '';
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file.".codex/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = configFormat.generate "codex-config" cfg.settings;
    };
    home.file.".codex/AGENTS.md" = lib.mkIf (cfg.guidance != "") {
      text = cfg.guidance;
    };
  };
}
