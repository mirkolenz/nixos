{
  user,
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
    users.mirko = {
      description = "Mirko Lenz";
      home = "/home/mirko";
      uid = lib.mkDefault 1000;
      isNormalUser = true;
      hashedPasswordFile = lib.mkDefault "/etc/nixos/secrets/mirko.passwd";
      openssh.authorizedKeys.keys = user.sshKeys;
    };
    users.mila = {
      description = "Mila Lenz";
      home = "/home/mila";
      uid = lib.mkDefault 1001;
      isNormalUser = true;
      hashedPasswordFile = lib.mkDefault "/etc/nixos/secrets/mila.passwd";
    };
    users.levi = {
      description = "Levi Lenz";
      home = "/home/levi";
      uid = lib.mkDefault 1002;
      isNormalUser = true;
      hashedPasswordFile = lib.mkDefault "/etc/nixos/secrets/levi.passwd";
    };
  };
}
