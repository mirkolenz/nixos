{ user, ... }:
{
  nix = {
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
      trusted-users = [
        "root"
        user.login
      ];
    };
  };
}
