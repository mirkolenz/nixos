{
  lib',
  inputs,
  nixpkgsArgs,
  lib,
  self,
  ...
}:
{
  imports = lib'.flocken.getModules ./.;
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit (nixpkgsArgs) config overlays;
      };
      legacyPackages = pkgs.exported-functions // {
        exported-packages = lib.filterAttrs (
          _: value: lib.meta.availableOn pkgs.stdenv.hostPlatform value
        ) pkgs.exported-packages;
        inherit (pkgs) exported-functions;
      };
      packages = config.legacyPackages.exported-packages // {
        default = pkgs.mkBuilder { flake = self; };
        inherit (pkgs)
          home-manager
          nixos-rebuild-ng
          darwin-rebuild
          darwin-uninstaller
          ;
      };
    };
  flake = {
    lib = lib'.self;
  };
}
