{
  user,
  config,
  lib',
  os,
  ...
}:
{
  custom.nix.settings = {
    allowed-users = [ user.login ];
  };
  nix = {
    inherit (config.custom.nix) settings;
    extraOptions = ''
      !include nix.secrets.conf
    '';
    registry = lib'.mkRegistry os;
  };
}
