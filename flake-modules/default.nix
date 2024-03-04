{
  lib',
  inputs,
  specialModuleArgs,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = import ../nixpkgs-config.nix;
        overlays = import ../overlays specialModuleArgs;
      };
      formatter = pkgs.nixfmt;
    };
  flake = {
    lib = lib'.self;
  };
}
