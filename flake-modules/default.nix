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
            builder-wrapper
            ;
        };
      };
      packages = config.legacyPackages.exports // {
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
