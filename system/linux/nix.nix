{ user, config, ... }:
{
  custom.nix.settings = {
    allowed-users = [
      user.login
      "@wheel"
    ];
    sandbox = true;
  };
  nix = {
    inherit (config.custom.nix) settings;
    extraOptions = ''
      !include nix.secrets.conf
    '';
    channel.enable = false;
  };
  # we do this ourselves
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
