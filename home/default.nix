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
    if lib.versionAtLeast lib.trivial.release "23.11"
    then inputs.nixvim-unstable
    else inputs.nixvim-linux-stable;
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
