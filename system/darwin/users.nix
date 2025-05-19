{ user, ... }:
{
  system.primaryUser = user.login;
  users.knownUsers = [ user.login ];
}
