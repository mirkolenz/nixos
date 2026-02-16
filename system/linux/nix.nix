{
  user,
  lib',
  os,
  ...
}:
{
  custom.nix.settings = {
    allowed-users = [ user.login ];
  };
  nix = {
    extraOptions = ''
      !include nix.secrets.conf
    '';
    registry = lib'.mkRegistry os;
  };
  # we do this ourselves
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
