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
  cfg = config.programs.codex;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.codex = {
    enable = mkEnableOption "codex";

    package = mkPackageOption pkgs "codex" { nullable = true; };

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
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.file.".codex/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = configFormat.generate "codex-config" cfg.settings;
    };
  };
}
