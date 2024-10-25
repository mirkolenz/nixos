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
      lib,
      config,
      ...
    }:
    let
      inherit (lib'.self) filterAttrsByPlatform;
      inherit (lib.platforms) darwin linux;
      filterPkgsByPlatform = platforms: filterAttrsByPlatform system platforms pkgs.flake-exposed;
    in
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit (nixpkgsArgs) config overlays;
      };
      checks = config.packages;
      packages =
        (filterPkgsByPlatform (darwin ++ linux))
        // (filterPkgsByPlatform darwin)
        // (filterPkgsByPlatform linux)
        // {
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
