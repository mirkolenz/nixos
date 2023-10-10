{
  pkgsUnstable,
  pkgsStable,
  extras,
  flakeInputs,
  ...
}: let
  defaults = {...}: {
    _module.args = {
      inherit extras flakeInputs pkgsUnstable pkgsStable;
      username = "mlenz";
    };
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
