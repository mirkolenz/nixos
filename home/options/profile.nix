{ lib, osConfig, ... }:
{
  options.custom.profile = lib.mkOption {
    description = "Path to secrets file";
    type =
      with lib.types;
      nullOr (enum [
        "workstation"
        "server"
        "headless"
      ]);
  };
  config.custom.profile = lib.mkIf (osConfig ? custom.profile) osConfig.custom.profile;
}
