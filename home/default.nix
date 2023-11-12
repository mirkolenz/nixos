{
  extras,
  inputs,
  config,
  lib,
  ...
}: let
  defaults = {...}: {
    _module.args = {
      inherit extras inputs;
      userLogin = extras.user.login;
    };
  };
  nixvimInput =
    if lib.trivial.release == "23.05"
    then inputs.nixvim-linux-stable
    else inputs.nixvim-unstable;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mlenz.imports = [
      defaults
      ./mlenz
      inputs.nix-index-database.hmModules.nix-index
      nixvimInput.homeManagerModules.nixvim
    ];
  };
}
