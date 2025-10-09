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
    literalExpression
    types
    ;

  tomlFormat = pkgs.formats.toml { };
  cfg = config.programs.macchina;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.macchina = {
    enable = mkEnableOption "macchina";

    package = mkPackageOption pkgs "macchina" { nullable = true; };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          interface = "wlan0";
          long_uptime = true;
          long_shell = false;
          long_kernel = false;
          current_shell = true;
          physical_cores = true;
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/macchina/macchina.toml`.
        See <https://github.com/Macchina-CLI/macchina/blob/main/macchina.toml>
        for more information.
      '';
    };

    themes = mkOption {
      type = types.attrsOf (
        types.oneOf [
          tomlFormat.type
          types.path
          types.str
        ]
      );
      default = { };
      example = literalExpression ''
        {
          Lithium = "''${config.programs.macchina.package.src}/contrib/themes/Lithium.toml";
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/macchina/themes/*.toml`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile = lib.mkMerge [
      {
        "macchina/macchina.toml" = lib.mkIf (cfg.settings != { }) {
          source = tomlFormat.generate "macchina-config.toml" cfg.settings;
        };
      }
      (lib.mkIf (cfg.themes != { }) (
        lib.mapAttrs' (name: value: {
          name = "macchina/themes/${name}.toml";
          value.source =
            if lib.isAttrs value then tomlFormat.generate "macchina-theme-${name}.toml" value else value;
        }) cfg.themes
      ))
    ];
  };
}
