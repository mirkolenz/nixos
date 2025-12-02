{
  user,
  pkgs,
  lib,
  ...
}:
{
  system.primaryUser = user.login;
  users = {
    knownUsers = [ user.login ];
    users.${user.login} = {
      description = user.name;
      home = "/Users/${user.login}";
      shell = pkgs.fish;
      uid = lib.mkDefault 501;
      gid = lib.mkDefault 20;
    };
  };
}
