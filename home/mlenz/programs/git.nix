{
  lib,
  pkgs,
  user,
  ...
}: {
  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.mail;
    lfs = {
      enable = true;
    };
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
      display = "side-by-side"; # "side-by-side", "side-by-side-show-both", "inline"
    };
    ignores = lib.splitString "\n" (builtins.readFile ../files/.gitignore);
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "nvim";
        eol = "lf";
      };
      fetch = {
        prune = true;
        pruneTags = true;
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
