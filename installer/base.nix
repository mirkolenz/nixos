{
  lib,
  stateVersion,
  user,
  ...
}:
{
  system = {
    inherit stateVersion;
  };
  users.users.root.openssh.authorizedKeys.keys = user.sshKeys;
  systemd.services.sshd.wantedBy = lib.mkForce [ "multi-user.target" ];
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
