{
  lib,
  pkgs,
  user,
  ...
}:
{
  home.packages = with pkgs; [
    gibo
    git-ignore
    lazyjj
    diffedit3
  ];
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
  programs.gh-dash = {
    enable = true;
  };
  programs.difftastic = {
    enable = true;
    git.enable = false;
    options = {
      background = "dark";
      color = "always";
      display = "inline"; # "side-by-side", "side-by-side-show-both", "inline"
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
    options = {
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
        hunk-header-decoration-style = "cyan box ul";
      };
      features = "decorations";
      hyperlinks = true;
      line-numbers = true;
      navigate = true;
      syntax-theme = "Monokai Extended";
      whitespace-error-style = "22 reverse";
    };
  };
  programs.git = {
    enable = true;
    lfs.enable = true;
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
    settings = {
      user = {
        name = user.name;
        email = user.mail;
      };
      core = {
        autocrlf = "input";
        # editor = "nvim";
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
    # https://docs.jj-vcs.dev/latest/config/
    settings = {
      # keep-sorted start block=yes
      aliases = {
        # keep-sorted start block=yes
        c = [
          "commit"
        ];
        ci = [
          "commit"
          "--interactive"
        ];
        clone = [
          "git"
          "clone"
        ];
        d = [
          "describe"
        ];
        e = [
          "edit"
        ];
        f = [
          "git"
          "fetch"
        ];
        fetch = [
          "git"
          "fetch"
        ];
        init = [
          "git"
          "init"
        ];
        n = [
          "new"
        ];
        nb = [
          "bookmark"
          "create"
          "--revision"
          "@-"
        ];
        p = [
          "git"
          "push"
        ];
        pull = [
          "git"
          "fetch"
        ];
        push = [
          "git"
          "push"
        ];
        r = [
          "rebase"
        ];
        remote = [
          "git"
          "remote"
        ];
        s = [
          "squash"
        ];
        si = [
          "squash"
          "--interactive"
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest_bookmark(@)"
          "--to"
          "closest_nonempty(@)"
        ];
        # keep-sorted end
      };
      # https://github.com/jj-vcs/jj/discussions/3549
      experimental-advance-branches = {
        enabled-branches = [
          "glob:*"
        ];
        disabled-branches = [
          "main"
          "glob:push-*"
        ];
      };
      git = {
        fetch = [
          "upstream"
          "origin"
        ];
        push = "origin";
      };
      remotes = {
        origin.auto-track-bookmarks = "glob:*";
        upstream.auto-track-bookmarks = "main";
      };
      revset-aliases = {
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_nonempty(to)" = "heads(::to ~ empty())";
      };
      ui = {
        default-command = "log";
        diff-editor = ":builtin";
        # editor = "nvim";
      };
      user = {
        name = user.name;
        email = user.mail;
      };
      # keep-sorted end
    };
  };
  programs.jjui = {
    enable = true;
  };
  programs.gitui = {
    enable = true;
    package = pkgs.gitui-bin;
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
        # https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
        pagers = [
          {
            pager = "delta --paging=never --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
          }
          {
            externalDiffCommand = "difft --color=always --display=inline";
          }
        ];
      };
      os.editPreset = "zed";
      update.method = "never";
      disableStartupPopups = true;
    };
  };
}
