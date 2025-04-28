{
  pkgs,
  lib,
  config,
  lib',
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
{
  imports = lib'.flocken.getModules ./.;

  home.packages = with pkgs; [
    mas
    goneovim-bin
    restic-browser-bin
    undmg
    rcodesign
    vimr-bin
    infat-bin
    (writeShellApplication {
      name = "scansnap-reset";
      text = ''
        pkill -f ScanSnap
        open --hide /Applications/ScanSnapHomeMain.app
      '';
    })
  ];
  home.file = {
    "bin".source = mkLinkFarm {
      name = "home-bin";
      paths = {
        git = config.programs.git.package;
        nvim = config.custom.neovim.package;
        restic = pkgs.restic;
      };
      transform = lib.getExe;
    };
    "lib".source = mkLinkFarm {
      name = "home-lib";
      paths = {
        prettier = pkgs.nodePackages.prettier;
      };
      transform = x: "${lib.getLib x}/lib";
    };
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary" = {
      source = ../dictionary.txt;
    };
  };
  home.shellAliases = {
    copy = ''${lib.getExe' pkgs.coreutils "tr"} -d '\n' | pbcopy'';
    zed = "zed-preview";
  };
}
