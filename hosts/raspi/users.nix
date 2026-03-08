{ user, ... }:
{
  users.users = {
    ${user.login}.hashedPasswordFile = "/etc/nixos/secrets/${user.login}.passwd";
  };
}
