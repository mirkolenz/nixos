{ user, ... }:
{
  users.users.root.openssh.authorizedKeys.keys = user.sshKeys;
  services.openssh.enable = true;

  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
