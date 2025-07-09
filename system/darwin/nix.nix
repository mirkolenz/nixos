{
  user,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    package = lib.mkForce pkgs.nixVersions.latest;
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
      trusted-users = [ user.login ];
      sandbox = false;
    };
  };
}
