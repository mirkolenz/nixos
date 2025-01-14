{
  pkgs,
  lib,
  config,
  ...
}:
let
  mkLinkFarm =
    {
      name,
      paths,
      transform ? x: x,
    }:
    pkgs.linkFarm name (
      lib.mapAttrsToList (name: value: {
        inherit name;
        path = transform value;
      }) paths
    );
in
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [
    mas
    zigstar-multitool
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
    "bin".source = mkLinkFarm {
      name = "home-bin";
      paths = {
        restic = pkgs.restic;
        git = config.programs.git.package;
        nvim = config.custom.neovim.package;
      };
      transform = lib.getExe;
    };
    # add libraries for desktop apps to ~/node_modules
    # currently required for the following apps:
    # vscode/prettier
    "lib".source = mkLinkFarm {
      name = "home-lib";
      paths = {
        prettier = pkgs.nodePackages.prettier;
      };
      transform = x: "${lib.getLib x}/lib";
    };
    # add entries to the local dictionary
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary" = {
      source = ./dictionary.txt;
    };
  };
  home.sessionVariables = {
    EDITOR = "code -w";
  };
  home.shellAliases = {
    copy = ''${lib.getExe' pkgs.coreutils "tr"} -d '\n' | pbcopy'';
  };
  programs.ssh.includes = [
    "${config.home.homeDirectory}/.orbstack/ssh/config"
  ];
}
