{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.infat;
  tomlFormat = pkgs.formats.toml { };
  infatSettings = tomlFormat.generate "infat-settings" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options = {
    programs.infat = {
      enable = lib.mkEnableOption "infat";
      package = lib.mkPackageOption pkgs "infat" {
        nullable = true;
      };
      settings = lib.mkOption {
        type = tomlFormat.type;
        default = { };
        example = lib.literalExpression ''
          {
            files = {
              md = "TextEdit";
              html = "Safari";
              pdf = "Preview";
            };
            schemes = {
              mailto = "Mail";
              web = "Safari";
            };
          }
        '';
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/infat/config.toml`.
        '';
      };
      autoActivate = lib.mkEnableOption "auto-activate infat" // {
        default = true;
        example = false;
        description = ''
          Automatically activate infat on startup.
          This is useful if you want to use infat as a
          default application handler for certain file types.
          If you don't want this, set this to false.
          This option is only effective if `settings` is set.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
    xdg.configFile."infat/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = infatSettings;
    };
    home.activation = lib.mkIf (cfg.settings != { } && cfg.autoActivate) {
      infat = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ${lib.getExe cfg.package} --quiet --config ${infatSettings} $VERBOSE_ARG
      '';
    };
  };
}
