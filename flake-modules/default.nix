{
  lib',
  inputs,
  specialModuleArgs,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
  perSystem =
    {
      pkgs,
      system,
      lib,
      config,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = import ../nixpkgs-config.nix;
        overlays = import ../overlays specialModuleArgs;
      };
      checks = config.packages;
      packages =
        pkgs.custom.common
        // (lib.optionalAttrs pkgs.stdenv.isDarwin pkgs.custom.darwin)
        // (lib.optionalAttrs pkgs.stdenv.isLinux pkgs.custom.linux);
    };
  flake = {
    lib = lib'.self;
  };
}
