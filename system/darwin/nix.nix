{
  user,
  config,
  lib,
  ...
}:
{
  determinate-nix.customSettings = lib.mapAttrs (
    # workaround: upstream serializes as json which is wrong
    # https://github.com/DeterminateSystems/determinate/blob/main/modules/nix-darwin/config/config.nix
    name: value: if builtins.isList value then toString value else value
  ) config.custom.nix.settings;
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
