{ extras, ... }:
let
  defaults = { ... }: {
    _module.args = { inherit extras; };
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mlenz.imports = [
      defaults
      ./mlenz
    ];
  };
}
