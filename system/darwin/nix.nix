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
      # https://github.com/NixOS/nix/issues/4119#issuecomment-2561973914
      extra-sandbox-paths = [ "/nix/store" ];
      sandbox = "relaxed";
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };
}
