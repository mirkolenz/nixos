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
      checks = config.packages;
      packages = lib'.self.filterPackagePlatforms {
        inherit system;
        packages = pkgs.flake-exports // {
          inherit (pkgs)
            home-manager
            nixos-rebuild
            darwin-rebuild
            darwin-uninstaller
            ;
        };
      };
    };
  flake = {
    lib = lib'.self;
  };
}
