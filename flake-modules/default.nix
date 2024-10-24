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
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit (nixpkgsArgs) config overlays;
      };
      checks = config.packages;
      packages =
        (lib'.self.filterAttrsByPlatform system (lib.platforms.darwin ++ lib.platforms.linux) pkgs.custom)
        // (lib'.self.filterAttrsByPlatform system lib.platforms.darwin pkgs.custom)
        // (lib'.self.filterAttrsByPlatform system lib.platforms.linux pkgs.custom)
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
