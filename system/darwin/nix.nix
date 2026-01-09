{
  user,
  config,
  lib',
  os,
  ...
}:
{
  # https://github.com/DeterminateSystems/determinate/blob/main/modules/nix-darwin/default.nix
  determinateNix = {
    customSettings = config.custom.nix.settings;
    registry = lib'.mkRegistry os;
    # https://docs.determinate.systems/determinate-nix#determinate-nixd-configuration
    determinateNixd = {
      builder.state = "disabled";
      garbageCollector.strategy = "automatic";
    };
  };
  environment.etc."nix/nix.custom.conf".text = ''
    !include nix.secrets.conf
  '';
  nix.enable = false;
  custom.nix.settings = {
    allowed-users = [
      user.login
      "@staff"
    ];
    trusted-users = [
      user.login
      "root"
    ];
    sandbox = false;
  };
}
