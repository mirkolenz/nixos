attrs @ {
  extras,
  specialArgNames,
  moduleArgNames,
  lib,
  ...
}: let
  moduleArgs = lib.genAttrs moduleArgNames (name: attrs.${name});
  specialArgs = lib.genAttrs specialArgNames (name: attrs.${name});
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    users.mlenz.imports = [
      ./mlenz
      {
        _module.args = moduleArgs;
      }
    ];
  };
}
