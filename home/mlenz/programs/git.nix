{
  lib,
  pkgs,
  user,
  ...
}:
{
  home.packages = with pkgs; [
    git-annex
  ];
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
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
    delta = {
      enable = true;
    };
    ignores = [
      # nix
      "/.direnv/"
      "/.devenv/"
      ".envrc"
      ".env"
      "/result"
      # mac
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*.icloud"
      # linux
      "*~"
      ".fuse_hidden*"
      ".directory"
      ".Trash-*"
      ".nfs*"
      # windows
      "Thumbs.db"
      "Thumbs.db:encryptable"
      "ehthumbs.db"
      "ehthumbs_vista.db"
      "*.stackdump"
      "[Dd]esktop.ini"
      "$RECYCLE.BIN/"
      # vscode
      ".vscode/*"
      "!.vscode/settings.json"
      "!.vscode/tasks.json"
      "!.vscode/launch.json"
      "!.vscode/extensions.json"
      "!.vscode/*.code-snippets"
    ];
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "nvim";
        eol = "lf";
        fsmonitor = lib.mkIf pkgs.stdenv.isDarwin true; # not supported on linux
      };
      index = {
        # otherwise, treefmt has the following error: failed to generate change set: failed to open git index: invalid checksum
        skipHash = false;
      };
      feature = {
        manyFiles = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        writeCommitGraph = true;
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
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = user.name;
        email = user.mail;
      };
    };
  };
  programs.gitui = {
    enable = true;
  };
  programs.lazygit = {
    enable = true;
  };
}
