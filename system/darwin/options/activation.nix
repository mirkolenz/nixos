{ lib, config, ... }:
{
  # Not possible to set via Nix, because all `dict` entries are prefixed with `-string`
  system.activationScripts.extraUserActivation.text = lib.concatLines [
    (lib.optionalString (config.custom.dock.persistentApps != [ ]) config.custom.dock.activationScript)
  ];
}
