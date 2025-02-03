{ user, ... }:
{
  nix = {
    settings = {
      build-users-group = "nixbld";
      allowed-users = [ "@staff" ];
      trusted-users = [ user.login ];
      # https://github.com/NixOS/nix/issues/4119#issuecomment-2561973914
      extra-sandbox-paths = [ "/nix/store" ];
    };
    gc.interval = {
      Hour = 1;
      Minute = 0;
    };
  };
}
