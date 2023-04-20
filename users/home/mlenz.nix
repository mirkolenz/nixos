{ lib, config, osConfig, pkgs, extras, ... }:
let
  # inherit (lib.attrsets) optionalAttrs;
  inherit (pkgs) stdenv;
  inherit (extras) username dummyPackage;
  inherit (extras.inputs) gitignore;
  homeDirectory = if stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
  poetryPrefix = if stdenv.isDarwin then "Library/Preferences/pypoetry" else "${config.xdg.configHome}/pypoetry";
in {
  nixpkgs.config.allowUnfree = true;
  home = {
    inherit username;
    inherit (extras) stateVersion;
    homeDirectory = lib.mkDefault homeDirectory;
    file = {
      "${poetryPrefix}/config.toml" = {
        text = ''
          [virtualenvs]
          in-project = true
          prefer-active-python = true
        '';
      };
      ".latexmkrc" = {
        # https://man.cx/latexmk
        # https://www.overleaf.com/learn/how-to/How_does_Overleaf_compile_my_project%3F
        text = ''
          # 1: pdflatex
          # 4: lualatex
          # 5: xelatex
          $pdf_mode = 4;

          # Regular
          $pdflatex = "pdflatex %O %S";
          $xelatex = "xelatex %O %S";
          $lualatex = "lualatex %O %S";

          # Shell escape
          # $pdflatex = "pdflatex -shell-escape %O %S";
          # $xelatex = "xelatex -shell-escape %O %S";
          # $lualatex = "lualatex -shell-escape %O %S";

          # Texmf path
          # $ENV{"TEXINPUTS"} = "./texmf//:" . $ENV{"TEXINPUTS"};
          # $ENV{"BSTINPUTS"} = "./texmf//:" . $ENV{"BSTINPUTS"};
          # $ENV{"BIBINPUTS"} = "./texmf//:" . $ENV{"BIBINPUTS"};

          $postscript_mode = $dvi_mode = 0;
          $clean_ext = "";
          $ENV{"TZ"} = "Europe/Berlin";
        '';
      };
      ".mackup.cfg" = lib.mkIf stdenv.isDarwin {
        text = ''
          [storage]
          engine = icloud

          [applications_to_sync]
          bartender
          bibdesk
          default-folder-x
          defaultkeybinding
          docker
          forklift
          iina
          istat-menus
          iterm2
          mackup
          postico
          rstudio
          sublime-text-3
          tableplus
          xcode
        '';
      };
    };
  };

  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set nocompatible

        syntax on

        set autoindent
        set ruler
        set mouse=a
        set ignorecase
        set smartcase

        set tabstop=4
        set shiftwidth=0
        set noexpandtab

        set clipboard=unnamed

        " Use 'jk' to enter insert mode
        inoremap jk <esc>

        " Use 'return' to clear the highlighting of the last search
        " https://stackoverflow.com/a/662914
        " nnoremap <CR> :noh<CR><CR>

        " Use 'shift+return' to prepend new line
        nmap <S-Enter> O<Esc>

        " Use 'return' to append new line
        nmap <CR> o<Esc>

        " Do not yank deleted content
        nnoremap d "_d
        vnoremap d "_d

        colorscheme slate

        if !has('nvim')
          set ttymouse=xterm2
        endif

        if has('nvim')
          tnoremap <Esc> <C-\><C-n>
        endif
      '';
    };
    htop = {
      enable = true;
    };
    micro = {
      enable = true;
      settings = {
        autoclose = true;
        autoindent = true;
        autosave = 0;
        backup = true;
        basename = false;
        colorcolumn = 0;
        colorscheme = "monokai";
        comment = true;
        cursorline = true;
        diff = true;
        diffgutter = false;
        encoding = "utf-8";
        eofnewline = true;
        fastdirty = true;
        fileformat = "unix";
        filetype = "unknown";
        ftoptions = true;
        hidehelp = false;
        ignorecase = false;
        indentchar = " ";
        infobar = true;
        keepautoindent = false;
        keymenu = false;
        linter = true;
        literate = true;
        matchbrace = false;
        matchbraceleft = false;
        mkparents = false;
        mouse = true;
        paste = false;
        pluginchannels = [
            "https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json"
        ];
        pluginrepos = [];
        readonly = false;
        rmtrailingws = false;
        ruler = true;
        savecursor = false;
        savehistory = true;
        saveundo = false;
        scrollbar = false;
        scrollmargin = 3;
        scrollspeed = 2;
        smartpaste = true;
        softwrap = false;
        splitbottom = true;
        splitright = true;
        status = true;
        statusformatl = "$(filename) $(modified)($(line),$(col)) $(status.paste)| ft:$(opt:filetype) | $(opt:fileformat) | $(opt:encoding)";
        statusformatr = "$(bind:ToggleKeyMenu): bindings, $(bind:ToggleHelp): help";
        statusline = true;
        sucmd = "sudo";
        syntax = true;
        tabmovement = false;
        tabsize = 4;
        tabstospaces = false;
        termtitle = false;
        useprimary = true;
      };
    };
    ssh = {
      enable = true;
      matchBlocks = {
        "*" = {
          extraOptions = lib.mkIf stdenv.isDarwin {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
          };
          identityFile = [ "id_ed25519" "id_rsa" ];
        };
        wi2gpu = {
          hostname = "136.199.130.136";
          forwardAgent = true;
          user = "mlenz";
        };
        wi2v214 = {
          hostname = "v214.wi2.uni-trier.de";
          forwardAgent = true;
          user = "lenz";
        };
        homeserver = {
          hostname = "10.16.2.22";
          forwardAgent = true;
          user = "mlenz";
        };
        wi2docker = {
          hostname = "docker.wi2.uni-trier.de";
          user = "container";
        };
      };
    };
    # texlive = {
    #   enable = true;
    # };
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
    };
    bash = {
      enable = true;
    };
    fish = {
      enable = true;
      shellAliases = {
        dc = "docker compose";
        ls = "exa";
        ll = "exa -l";
        la = "exa -la";
        l = "exa -l";
        py = "poetry run python -m";
        hass = "hass-cli";
      };
      # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1266049484
      loginShellInit = ''
        if test (uname) = Darwin
          for p in (string split " " $NIX_PROFILES)
            fish_add_path --prepend --move $p/bin
          end
        end
      '';
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting ""
      '';
      functions = {
        dockerup = {
          body = ''
            sudo docker compose pull $argv
            sudo docker compose build $argv
            sudo docker compose up --detach
            sudo docker image prune --all --force
          '';
          description = "Update all docker-compose containers";
        };
        docker-reset = {
          body = ''
            sudo docker system prune --all --force
          '';
          description = "Reset docker";
        };
        encrypt = {
          description = "Encrypt a file using gpg";
          body = ''
            gpg --output "$target" --encrypt --recipient "$recipient" "$source"
          '';
          argumentNames = [ "source" "target" "recipient" ];
        };
        decrypt = {
          description = "Decrypt a file using gpg";
          body = ''
            gpg --output "$target" --decrypt "$source"
          '';
          argumentNames = [ "source" "target" ];
        };
        backup = {
          description = "Backup a directory to a tar.gz file";
          body = ''
            mkdir -p "$target"
            sudo tar czf "$target/$(date +"%Y-%m-%d-%H-%M-%S").tgz" "$source"
          '';
          argumentNames = [ "source" "target" ];
        };
        restore = {
          description = "Backup a directory to a tar.gz file";
          body = ''
            mkdir -p "$target"
            sudo tar xf "$source" -C "$target"
          '';
          argumentNames = [ "source" "target" ];
        };
        divider = {
          body = ''
            set length (tput cols)
            set char =
            tput bold

            echo
            printf "%*s\n" $length "" | tr " " $char
            echo

            tput sgr0
          '';
          description = "Print a bold horizontal line";
        };
        otf2ttf = {
          body = ''
            fontforge -c 'Open("$source"); Generate("$target")'
          '';
          description = "Convert an OpenType font to TrueType";
          wraps = "fontforge";
          argumentNames = [ "source" "target" ];
        };
      };
    };
    git = {
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
          rebase = "true";
        };
        rebase = {
          autoStash = "true";
        };
        init = {
          defaultBranch = "main";
        };
        push = {
          followTags = "true";
          autoSetupRemote = "true";
        };
      };
    };
    direnv = lib.mkIf (stdenv.isDarwin || osConfig.services.xserver.enable) {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    vscode = lib.mkIf (stdenv.isLinux && osConfig.services.xserver.enable) {
      enable = true;
      package = pkgs.vscode.fhs;
    };
    alacritty = lib.mkIf (stdenv.isDarwin || (stdenv.isLinux && osConfig.services.xserver.enable)) {
      enable = true;
      # on macOS, we install it via brew and only want the settings
      package = lib.mkIf stdenv.isDarwin dummyPackage;
    };
  };
}
