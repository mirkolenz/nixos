{
  lib,
  pkgs,
  user,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    gibo
    git-ignore
    jjui
    lazyjj
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
      ".devenv"
      ".direnv"
      ".env"
      ".envrc"
      "result"
      "result-*"
      # editors
      ".idea/*"
      ".vscode/*"
      ".zed/*"
      # https://github.com/github/gitignore/blob/main/Global/macOS.gitignore
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon[]"
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
      # linux
      "*~"
      ".fuse_hidden*"
      ".directory"
      ".Trash-*"
      ".nfs*"
      "nohup.out"
      # https://github.com/github/gitignore/blob/main/Global/Windows.gitignore
      "Thumbs.db"
      "Thumbs.db:encryptable"
      "ehthumbs.db"
      "ehthumbs_vista.db"
      "*.stackdump"
      "[Dd]esktop.ini"
      "$RECYCLE.BIN/"
      "*.cab"
      "*.msi"
      "*.msix"
      "*.msm"
      "*.msp"
      "*.lnk"
    ];
    extraConfig = {
      core = {
        autocrlf = "input";
        editor = config.home.sessionVariables.EDITOR;
        eol = "lf";
        # not supported on linux
        # breaks nix flake operations with path references
        # https://github.com/NixOS/nix/issues/11567
        fsmonitor = lib.mkIf pkgs.stdenv.isDarwin true;
      };
      feature = {
        manyFiles = true;
      };
      column = {
        ui = "auto";
      };
      branch = {
        sort = "-committerdate";
      };
      tag = {
        sort = "version:refname";
      };
      help = {
        autocorrect = "prompt";
      };
      commit = {
        verbose = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      fetch = {
        all = true;
        prune = true;
        pruneTags = true;
        writeCommitGraph = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        followTags = true;
        autoSetupRemote = true;
      };
      remote = {
        # overwrite version tags
        origin.fetch = "+refs/tags/v*:refs/tags/v*";
      };
      difftool = {
        guiDefault = "auto";
        prompt = false;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
        guitool = "vscode";
      };
      mergetool = {
        guiDefault = "auto";
        prompt = false;
      };
      merge = {
        guitool = "vscode";
        conflictstyle = "zdiff3";
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
    keyConfig = "${pkgs.gitui.src}/vim_style_key_config.ron";
  };
  programs.lazygit = {
    enable = true;
    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    settings = {
      gui = {
        border = "single";
        nerdFontsVersion = "3";
        showCommandLog = false;
        showFileTree = true;
        showNumstatInFilesView = true;
        showRandomTip = false;
        skipDiscardChangeWarning = false;
        skipNoStagedFilesWarning = true;
        skipRewordInEditorWarning = false;
        skipStashWarning = false;
        splitDiff = "always";
        useHunkModeInStagingView = true;
      };
      git = {
        commit.autoWrapCommitMessage = false;
        parseEmoji = true;
        log = {
          order = "default";
          showGraph = "never";
        };
      };
      os.editPreset = "zed";
      update.method = "never";
      disableStartupPopups = true;
    };
  };
}
