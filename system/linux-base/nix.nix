{
  config,
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
  };
}
