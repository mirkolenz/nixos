{ lib, config, ... }:
let
  cfg = config.custom.dock;
  # https://stackoverflow.com/q/59614341
  mkEntry =
    path:
    "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${path}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
in
{
  options.custom.dock = with lib; {
    persistentApps = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "List of applications to keep in the dock";
    };
    activationScript = mkOption {
      type = with types; str;
      description = "Command to run for setting the apps";
      internal = true;
      readOnly = true;
      default = ''
        defaults write com.apple.dock persistent-apps -array ${lib.escapeShellArgs (map mkEntry cfg.persistentApps)}
      '';
    };
  };
}
