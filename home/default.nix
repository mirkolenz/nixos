{
  extras,
  flakeInputs,
  config,
  ...
}: let
  defaults = {...}: {
    _module.args = {inherit extras flakeInputs;};
    nixpkgs.config = config.nixpkgs.config;
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mlenz.imports = [
      defaults
      ./mlenz
      flakeInputs.nix-index-database.hmModules.nix-index
      flakeInputs.nixneovim.nixosModules.default
    ];
  };
}
