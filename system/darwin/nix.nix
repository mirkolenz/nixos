{
  user,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    package = lib.mkForce pkgs.nixVersions.nix_2_29;
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
      trusted-users = [ user.login ];
      sandbox = "relaxed";
    };
  };
}
