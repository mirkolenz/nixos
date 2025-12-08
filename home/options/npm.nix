# https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/programs/npm.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.npm;

  xdgConfigHome = lib.removePrefix config.home.homeDirectory config.xdg.configHome;
  configFile = if config.home.preferXdgDirectories then "${xdgConfigHome}/npm/npmrc" else ".npmrc";

  iniFormat = pkgs.formats.iniWithGlobalSection {
    listsAsDuplicateKeys = true;
  };
in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options = {
    programs.npm = {
      enable = lib.mkEnableOption "{command}`npm` user config";

      package = lib.mkPackageOption pkgs [ "nodejs" ] {
        example = "nodejs_24";
        nullable = true;
      };

      settings = lib.mkOption {
        type = iniFormat.type;
        description = ''
          The user-specific npm configuration.
          See <https://docs.npmjs.com/cli/using-npm/config> and
          <https://docs.npmjs.com/cli/configuring-npm/npmrc>
          for more information.

          **Notes:**
          - Top-level settings must be placed under the
            `globalSection` attribute.
          - Keys of list-valued settings must be suffixed
            with `[]` to be recognized as arrays by the npm parser.
        '';
        default = {
          globalSection = {
            prefix = "\${HOME}/.npm";
          };
        };
        example = lib.literalExpression ''
          {
            globalSection = {
              prefix = "''${HOME}/.npm";
              init-license = "MIT";
              color = true;
              "include[]" = [ "prod" "dev" ];
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (cfg.package != null) [ cfg.package ];
      file.${configFile} = lib.mkIf (cfg.settings != { }) {
        source = iniFormat.generate "npmrc" cfg.settings;
      };
      sessionVariables = lib.mkIf (cfg.settings != { }) {
        NPM_CONFIG_USERCONFIG = "${config.home.homeDirectory}/${configFile}";
      };
    };
  };
}
