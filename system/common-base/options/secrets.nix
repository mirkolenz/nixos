{ config, lib, ... }:
{
  options.custom = {
    secretsPath = lib.mkOption {
      description = "Path to secrets file";
      type = with lib.types; nullOr path;
      default = null;
    };
    secrets = lib.mkOption {
      description = "Secrets parsed from file";
      type = lib.types.attrs;
      default = if config.custom.secretsPath != null then import config.custom.secretsPath else { };
      defaultText = "import custom.secretsPath or {}";
      readOnly = true;
    };
  };
}
