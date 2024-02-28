{ pkgs, lib, ... }:
let
  iniFormat = pkgs.formats.ini { };
in
lib.mkIf pkgs.stdenv.isDarwin {
  home.file.".mackup.cfg".source = iniFormat.generate "mackup-config" {
    storage.engine = "icloud";
    applications_to_sync =
      lib.genAttrs
        [
          "bartender"
          "bibdesk"
          "default-folder-x"
          "defaultkeybinding"
          "docker"
          "forklift"
          "iina"
          "istat-menus"
          "iterm2"
          "mackup"
          "postico"
          "rstudio"
          "sublime-text-3"
          "tableplus"
          "xcode"
        ]
        (name: null);
  };
  # currently not packaged
  home.packages = with pkgs; [ mackup ];
}
