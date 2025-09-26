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
    (writeShellApplication {
      name = "scansnap-reset";
      text = ''
        pkill -f ScanSnap
        open --hide /Applications/ScanSnapHomeMain.app
      '';
    })
  ];
  programs.fish.loginShellInit = ''
    fish_add_path "${config.home.homeDirectory}/.local/bin"
  '';
  home.file = {
    ".local/bin".source = mkLinkFarm {
      name = "home-local-bin";
      paths = {
        git = config.programs.git.package;
        nvim = config.custom.neovim.package;
        restic = pkgs.restic;
      };
      transform = lib.getExe;
    };
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary" = {
      source = ../dictionary.txt;
    };
  };
  home.shellAliases = {
    copy = ''${lib.getExe' pkgs.coreutils "tr"} -d '\n' | pbcopy'';
  };
}
