{
  pkgs,
  lib,
  config,
  lib',
  ...
}:
{
  imports = lib'.flocken.getModules ./.;

  home.packages = with pkgs; [
    mas
    goneovim-bin
    restic-browser-bin
    codexbar-bin
    undmg
    rcodesign
    container
    ollama-copilot
    (writeShellApplication {
      name = "scansnap-reset";
      text = ''
        pkill -f ScanSnap
        open --hide /Applications/ScanSnapHomeMain.app
      '';
    })
    (writeShellApplication {
      name = "nixos";
      text = ''
        exec orbctl run --machine nixos "$@"
      '';
    })
  ];
  xdg.binFile = {
    git.source = lib.getExe config.programs.git.package;
    nvim.source = lib.getExe config.custom.neovim.package;
    restic.source = lib.getExe pkgs.restic;
  };
  home.file = {
    "Library/Group Containers/group.com.apple.AppleSpell/Library/Spelling/LocalDictionary".source =
      ../dictionary.txt;
  };
  home.shellAliases = {
    copy = ''${lib.getExe' pkgs.coreutils "tr"} -d '\n' | pbcopy'';
  };
  targets.darwin.copyApps.enableChecks = false; # requires sudo during activation
}
