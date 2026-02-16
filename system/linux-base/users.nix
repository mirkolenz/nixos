{
  pkgs,
  lib,
  ...
}:
{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users.root = {
      hashedPasswordFile = lib.mkDefault "/etc/nixos/secrets/root.passwd";
    };
  };
}
