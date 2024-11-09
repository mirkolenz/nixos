{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
    neovide-bin
    vimr-bin
    goneovim-bin
    restic-browser-bin
    neohtop-bin
    (writeShellApplication {
      name = "scansnap-reset";
      text = ''
        pkill -f ScanSnap
        open /Applications/ScanSnapHomeMain.app
      '';
    })
  ];
  # add binaries for desktop apps to ~/bin
  # currently required for the following apps:
  # restic-browser, git guis, vim guis
  home.file = {
    "bin".source =
      let
        mkPaths = lib.mapAttrsToList (
          name: value: {
            inherit name;
            path = lib.getExe value;
          }
        );
      in
      pkgs.linkFarm "home-bin" (mkPaths {
        restic = pkgs.restic;
        git = config.programs.git.package;
        nvim = config.custom.neovim.package;
      });
    # add libraries for desktop apps to ~/node_modules
    # currently required for the following apps:
    # vscode/prettier
    "lib".source =
      let
        mkPaths = lib.mapAttrsToList (
          name: value: {
            inherit name;
            path = "${lib.getLib value}/lib";
          }
        );
      in
      pkgs.linkFarm "home-lib" (mkPaths {
        prettier = pkgs.nodePackages.prettier;
      });
    # add entries to the local dictionary
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary".text = ''
      mirkolenz
      Argumentgraph
    '';
  };
  home.sessionVariables = {
    EDITOR = "code -w";
  };
}
