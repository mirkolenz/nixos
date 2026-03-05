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
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
    };
  };
}
