{ pkgs, ... }:
{
  custom.mackup = {
    # enable = pkgs.stdenv.isDarwin;
    settings = {
      storage.engine = "icloud";
    };
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
  };
}
