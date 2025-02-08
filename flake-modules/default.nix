{
  lib',
  inputs,
  nixpkgsArgs,
  lib,
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
      legacyPackages = {
        exports = lib.filterAttrs (_: value: lib.meta.availableOn system value) pkgs.flake-exports;
        github-checks = config.legacyPackages.exports // {
          inherit (config.packages)
            nixvim-stable
            nixvim-unstable
            builder
            ;
        };
      };
      packages = config.legacyPackages.exports // {
        default = config.packages.builder;
        inherit (pkgs)
          home-manager
          nixos-rebuild
          darwin-rebuild
          darwin-uninstaller
          ;
      };
    };
  flake = {
    lib = lib'.self;
  };
}
