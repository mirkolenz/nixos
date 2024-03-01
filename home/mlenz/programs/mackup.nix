{ pkgs, lib, ... }:
let
  iniFormat = pkgs.formats.ini { };
  mkList = values: lib.genAttrs values (_: "");

  builtinApps = [
    "bartender"
    "contexts"
    "coteditor"
    "defaultkeybinding"
    "fork"
    "iterm2"
    "tower"
  ];
  customApps = {
    # test = {
    #   application.name = "Test";
    #   configuration_files = mkList [ ".test" ];
    # };
  };
in
lib.mkIf pkgs.stdenv.isDarwin {
  home.file =
    {
      ".mackup.cfg".source = iniFormat.generate "mackup-config" {
        storage.engine = "icloud";
        applications_to_sync = mkList (builtinApps ++ builtins.attrNames customApps);
      };
    }
    // (lib.mapAttrs'
      (name: value: {
        name = ".mackup/${name}.cfg";
        value = {
          source = iniFormat.generate "mackup-config-${name}" value;
        };
      })
      customApps
    );
  home.packages = with pkgs; [ mackup ];
}
