{
  user,
  pkgs,
  lib,
  ...
}:
{
  users = {
    users.${user.login} = {
      description = user.name;
      home = "/home/${user.login}";
      shell = pkgs.fish;
      uid = lib.mkDefault 1000;
      group = user.login;
      # https://wiki.debian.org/SystemGroups#Other_System_Groups
      extraGroups = [
        "users"
        "wheel"
        "video"
        "audio"
      ];
      isNormalUser = true;
      hashedPasswordFile = lib.mkDefault "/etc/nixos/secrets/${user.login}.passwd";
      openssh.authorizedKeys.keys = user.sshKeys;
      subUidRanges = [
        {
          count = 65536;
          startUid = 100000;
        }
      ];
      subGidRanges = [
        {
          count = 65536;
          startGid = 100000;
        }
      ];
    };
    groups.${user.login} = {
      gid = lib.mkDefault 1000;
    };
  };
}
