attrs @ {
  extras,
  specialArgNames,
  moduleArgNames,
  lib,
  ...
}: let
  moduleArgs = lib.genAttrs moduleArgNames (name: attrs.${name});
  specialArgs = lib.genAttrs specialArgNames (name: attrs.${name});
  defaults = {lib, ...}: {
    _module.args = moduleArgs;
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = specialArgs;
    users.mlenz.imports = [
      ./mlenz
      defaults
    ];
  };
}
