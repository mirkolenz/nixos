{
  extras,
  inputs,
  ...
}: let
  defaults = {...}: {
    _module.args = {
      inherit extras inputs;
      userLogin = extras.user.login;
    };
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mlenz.imports = [
      defaults
      ./mlenz
      inputs.nix-index-database.hmModules.nix-index
      inputs.nixvim.homeManagerModules.nixvim
    ];
  };
}
