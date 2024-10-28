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
        binaries = {
          restic = pkgs.restic;
          git = config.programs.git.package;
          nvim = config.custom.neovim.package;
        };
        symbolicLinks = lib.mapAttrsToList (name: path: ''
          ln -s "${lib.getBin path}/bin/${name}" "$out/${name}"
        '') binaries;
      in
      pkgs.runCommand "home-bin" { } ''
        mkdir -p "$out"
        ${lib.concatLines symbolicLinks}
      '';
    # pkgs.linkFarm (
    #   lib.mapAttrsToList (name: path: {
    #     inherit name path;
    #   }) binaries
    # );
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary".text =
      lib.concatLines
        [
          "mirkolenz"
          "Argumentgraph"
        ];
  };
  home.sessionVariables = {
    EDITOR = "code -w";
  };
}
