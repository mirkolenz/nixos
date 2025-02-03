{ lib, ... }:
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
}
