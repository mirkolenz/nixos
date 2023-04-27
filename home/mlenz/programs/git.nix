{ extras, lib, pkgs, ... }:
let
  inherit (extras.inputs) gitignore;
in
{
  programs.git = {
    enable = true;
    userName = "Mirko Lenz";
    userEmail = "mirko@mirkolenz.com";
    lfs = {
      enable = true;
    };
    ignores = lib.splitString "\n" (builtins.readFile gitignore.outPath);
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "nvim";
        eol = "lf";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        followTags = true;
        autoSetupRemote = true;
      };
      difftool = {
        prompt = false;
        vscode.cmd = "code -dnw --diff --new-window --wait $LOCAL $REMOTE";
        kaleidoscope.cmd = "ksdiff --partial-changeset --relative-path $MERGED -- $LOCAL $REMOTE";
      };
      diff = {
        tool = lib.mkIf pkgs.stdenv.isDarwin "vscode";
      };
      mergetool = {
        prompt = false;
        vscode.cmd = "code --merge --new-window --wait $REMOTE $LOCAL $BASE $MERGED";
        kaleidoscope.cmd = "ksdiff --merge --output $MERGED --base $BASE -- $LOCAL --snapshot $REMOTE --snapshot";
      };
      merge = {
        tool = lib.mkIf pkgs.stdenv.isDarwin "vscode";
        trustExitCode = true;
      };
    };
  };
}
