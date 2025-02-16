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
        inherit (pkgs) exported-functions;
        exported-packages = lib.filterAttrs (
          _: value: lib.meta.availableOn pkgs.stdenv.hostPlatform value
        ) pkgs.exported-packages;
        checked-packages = config.legacyPackages.exported-packages // {
          inherit (config.packages)
            nixvim-unstable
            # nixvim-stable
            ;
        };
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
