{ user, ... }:
{
  users.users = {
    root.hashedPasswordFile = "/etc/nixos/secrets/root.passwd";
    ${user.login}.hashedPasswordFile = "/etc/nixos/secrets/${user.login}.passwd";
  };
}
