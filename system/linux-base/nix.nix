{
  config,
  lib',
  os,
  ...
}:
{
  custom.nix.settings = {
    allowed-users = [ "@wheel" ];
    sandbox = true;
  };
  nix = {
    inherit (config.custom.nix) settings;
    channel.enable = false;
    extraOptions = ''
      !include nix.secrets.conf
    '';
    registry = lib'.mkRegistry os;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
  };
  # we do this ourselves
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
