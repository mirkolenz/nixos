{ user, pkgs, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = user.sshKeys;
  services.openssh.enable = true;

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

  users.defaultUserShell = pkgs.fish;
}
