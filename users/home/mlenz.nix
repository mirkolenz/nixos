{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mlenz";
  # home.homeDirectory = "/Users/mlenz";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    fish = {
      enable = true;
      shellAliases = {
        dc = "docker compose";
      };
      # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1266049484
      loginShellInit = ''
        if test (uname) = Darwin
          for p in (string split " " $NIX_PROFILES)
            fish_add_path --prepend --move $p/bin
          end
        end
      '';
    };
    git = {
      enable = true;
      userName = "Mirko Lenz";
      userEmail = "mirko@mirkolenz.com";
      lfs = {
        enable = true;
      };
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
    # TODO: Enable only for GUI setups
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  };
}
