{
  ...
}:
{
  custom.nix.settings = {
    allowed-users = [ "@wheel" ];
    sandbox = true;
  };
  nix.channel.enable = false;
  # we do this ourselves
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
