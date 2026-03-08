{ ... }:
{
  users.users = {
    root.hashedPasswordFile = "/etc/nixos/secrets/root.passwd";
    mirko.hashedPasswordFile = "/etc/nixos/secrets/mirko.passwd";
  };
}
