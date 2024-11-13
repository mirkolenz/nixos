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
    ;

  tomlFormat = pkgs.formats.toml { };
  cfg = config.programs.uv;

in
{
  meta.maintainers = with lib.maintainers; [ mirkolenz ];

  options.programs.uv = {
    enable = mkEnableOption "uv";

    package = mkPackageOption pkgs "uv" { };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      example = literalExpression ''
        {
          python-downloads = "never";
          python-preference = "only-system";
          pip.index-url = "https://test.pypi.org/simple";
        }
      '';
      description = ''
        Configuration written to
        {file}`$XDG_CONFIG_HOME/uv/uv.toml`.
        See <https://docs.astral.sh/uv/configuration/files/>
        and <https://docs.astral.sh/uv/reference/settings/>
        for more information.
      '';
    };

    enableBashIntegration = (mkEnableOption "uv's bash integration") // {
      default = true;
    };

    enableZshIntegration = (mkEnableOption "uv's zsh integration") // {
      default = true;
    };

    enableFishIntegration = (mkEnableOption "uv's fish integration") // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."uv/uv.toml" = lib.mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "uv-config" cfg.settings;
    };

    programs.bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
      eval "$(${lib.getExe cfg.package} generate-shell-completion bash)"
      eval "$(${lib.getExe' cfg.package "uvx"} --generate-shell-completion bash)"
    '';

    programs.zsh.initExtra = lib.mkIf cfg.enableZshIntegration ''
      eval "$(${lib.getExe cfg.package} generate-shell-completion zsh)"
      eval "$(${lib.getExe' cfg.package "uvx"} --generate-shell-completion zsh)"
    '';

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
      ${lib.getExe cfg.package} generate-shell-completion fish | source
      ${lib.getExe' cfg.package "uvx"} --generate-shell-completion fish | source
    '';
  };
}
