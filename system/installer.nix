{ user, pkgs, ... }:
{
  services.openssh.enable = true;

  users = {
    defaultUserShell = pkgs.fish;

    users.root = {
      openssh.authorizedKeys.keys = user.sshKeys;
    };
  };

  programs = {
    git.enable = true;
    fish.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
