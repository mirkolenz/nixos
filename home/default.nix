{
  pkgs,
  lib,
  extras,
  flakeInputs,
  ...
}: let
  defaults = {...}: {
    _module.args = {inherit extras flakeInputs;};
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
      {
        # https://github.com/LnL7/nix-darwin/issues/701
        manual.manpages.enable = lib.mkIf pkgs.stdenv.isDarwin false;
      }
    ];
  };
}
