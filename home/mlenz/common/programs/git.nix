{
  lib,
  pkgs,
  user,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    git-annex
    gibo
    git-ignore
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
        editor = config.home.sessionVariables.EDITOR;
        eol = "lf";
        fsmonitor = lib.mkIf pkgs.stdenv.isDarwin true; # not supported on linux
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
        tool = lib.mkIf config.custom.profile.isDesktop "vscode";
      };
      mergetool = {
        prompt = false;
        vscode.cmd = "code --merge --new-window --wait $REMOTE $LOCAL $BASE $MERGED";
        kaleidoscope.cmd = "ksdiff --merge --output $MERGED --base $BASE -- $LOCAL --snapshot $REMOTE --snapshot";
      };
      merge = {
        tool = lib.mkIf config.custom.profile.isDesktop "vscode";
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
    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    settings = {
      gui = {
        border = "single";
        nerdFontsVersion = "";
        showCommandLog = false;
        showFileTree = true;
        showNumstatInFilesView = true;
        showRandomTip = false;
        skipDiscardChangeWarning = false;
        skipNoStagedFilesWarning = true;
        skipRewordInEditorWarning = false;
        skipStashWarning = false;
        splitDiff = "always";
      };
      git = {
        commit.autoWrapCommitMessage = false;
        parseEmoji = true;
      };
      os.editPreset = "zed";
      update.method = "never";
      disableStartupPopups = true;
    };
  };
}
