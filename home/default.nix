{
  extras,
  inputs,
  config,
  lib,
  ...
}: let
  defaults = {...}: {
    _module.args = {
      inherit extras;
      userLogin = extras.user.login;
    };
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.mlenz.imports = [
      defaults
      ./mlenz
    ];
  };
}
