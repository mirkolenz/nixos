{
  lib',
  inputs,
  nixpkgsArgs,
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
        exports = lib'.self.filterPackagePlatforms {
          inherit system;
          packages = pkgs.flake-exports;
        };
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
          nix-fast-build
          ;
      };
    };
  flake = {
    lib = lib'.self;
  };
}
